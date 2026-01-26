"use server";

import { revalidatePath } from "next/cache";
import type { StopType } from "@/generated/prisma";
import prisma from "@/lib/database/prisma";
import { withAuth } from "@/lib/permissions";

type UpdateEndClientDefaultStopTypeProps = {
  endClientId: string;
  clientId: string;
  defaultStopType: StopType | null;
};

export async function updateEndClientDefaultStopType({
  endClientId,
  clientId,
  defaultStopType,
}: UpdateEndClientDefaultStopTypeProps) {
  return withAuth(async (ctx, policies) => {
    policies.isDeliveryCompany();

    // Verify the client belongs to this delivery company
    const client = await prisma.company.findFirst({
      where: {
        id: clientId,
        parentId: ctx.company.id,
        type: "CLIENT",
      },
    });

    if (!client) throw new Error("Client not found");

    // Verify the end client belongs to this client
    const endClient = await prisma.company.findFirst({
      where: {
        id: endClientId,
        parentId: clientId,
        type: "END_CLIENT",
      },
    });

    if (!endClient) throw new Error("End client not found");

    // Update the default stop type
    await prisma.company.update({
      where: { id: endClientId },
      data: { defaultStopType },
    });

    revalidatePath(`/clients/${clientId}`);
  });
}
