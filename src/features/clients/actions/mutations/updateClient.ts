"use server";

import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import type { UpdateClientFormInput } from "@/features/clients/schemas/updateClient";
import prisma from "@/lib/database/prisma";
import { withAuth } from "@/lib/permissions";

type UpdateClientProps = {
  clientId: string;
  input: UpdateClientFormInput;
};

export async function updateClient({ clientId, input }: UpdateClientProps) {
  return withAuth(async (ctx, policies) => {
    const client = await prisma.company.findUnique({
      where: {
        id: clientId,
        parentId: ctx.company.id,
      },
    });

    if (!client) throw new Error("Client not found");
    policies.canUpdateClient(client);

    const { address: addressInput, cutoffTime, ...clientInput } = input;

    await prisma.company.update({
      where: {
        id: clientId,
        parentId: ctx.company.id,
      },
      data: {
        ...clientInput,
        address: {
          update: {
            ...addressInput,
          },
        },
      },
      include: { address: true },
    });

    // Update or new client settings if cutoffTime is provided and client is CLIENT type
    if (client.type === "CLIENT" && cutoffTime !== undefined) {
      await prisma.clientSettings.upsert({
        where: {
          clientCompanyId: clientId,
        },
        create: {
          clientCompanyId: clientId,
          cutoffTime: cutoffTime || null,
        },
        update: {
          cutoffTime: cutoffTime || null,
        },
      });
    }

    revalidatePath("/clients");
    revalidatePath(`/clients/${clientId}`);
    redirect(`/clients/${clientId}`);
  });
}
