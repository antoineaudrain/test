"use server";

import type { ClientWithRelations } from "@/features/clients/types";
import prisma from "@/lib/database/prisma";
import { withAuth } from "@/lib/permissions";

export type GetClientReturn = ClientWithRelations<{
  address: true;
  clientCompanies: {
    include: { address: true };
    orderBy: { createdAt: "asc" };
  };
  clientSettings: true;
}> | null;

type GetClientProps = {
  clientId: string;
};

export async function getClient({ clientId }: GetClientProps) {
  return withAuth<GetClientReturn>(async (ctx, policies) => {
    const client = await prisma.company.findFirst({
      where: {
        id: clientId,
        parentId: ctx.company.id,
      },
      include: {
        address: true,
        clientCompanies: {
          include: {
            address: true,
          },
          orderBy: {
            createdAt: "asc",
          },
        },
        clientSettings: true,
      },
    });

    if (!client) throw new Error("Client not found");
    policies.canViewClient(client);

    return client;
  });
}
