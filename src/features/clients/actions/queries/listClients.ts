"use server";

import type { ClientWithRelations } from "@/features/clients/types";
import prisma from "@/lib/database/prisma";
import { withAuth } from "@/lib/permissions";

type ListEmployeeReturn = ClientWithRelations<{
  address: true;
  clientCompanies: true;
}>[];

type ListClientsProps = {
  clientId?: string;
};

export async function listClients({ clientId }: ListClientsProps = {}) {
  return withAuth<ListEmployeeReturn>(async (ctx, policies) => {
    const clients = await prisma.company.findMany({
      where: clientId
        ? {
            parentCompany: {
              id: clientId,
              parentId: ctx.company.id,
            },
          }
        : {
            parentId: ctx.company.id,
          },
      include: {
        address: true,
        clientCompanies: true,
      },
    });

    policies.canViewClients(clients);

    return clients;
  });
}
