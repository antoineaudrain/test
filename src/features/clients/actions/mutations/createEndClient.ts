"use server";

import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import type { CreateEndClientFormInput } from "@/features/clients/schemas/createEndClient";
import prisma from "@/lib/database/prisma";
import { withAuth } from "@/lib/permissions";

type CreateEndClientProps = {
  input: CreateEndClientFormInput;
};

export async function createEndClient({
  input,
}: CreateEndClientProps): Promise<void> {
  return withAuth<void>(async (ctx, policies) => {
    policies.canCreateEndClientCompany();

    const { address: addressInput, ...clientInput } = input;

    const client = await prisma.company.create({
      data: {
        ...clientInput,
        type: "END_CLIENT",
        parentCompany: {
          connect: ctx.company,
        },
        address: {
          create: addressInput,
        },
      },
      include: { address: true },
    });

    revalidatePath("/clients");
    revalidatePath(`/clients/${client.id}`);
    redirect(`/clients`);
  });
}
