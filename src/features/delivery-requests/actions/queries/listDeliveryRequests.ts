"use server";

import type { DeliveryRequestWithStops } from "@/features/delivery-requests/types";
import prisma from "@/lib/database/prisma";
import { withAuth } from "@/lib/permissions";

export async function listDeliveryRequests(): Promise<
  DeliveryRequestWithStops[]
> {
  return withAuth<DeliveryRequestWithStops[]>(async (ctx, policies) => {
    // 1. Validate permissions
    policies.canViewDeliveryRequestListPage();

    // 2. Get requests for client company
    const requests = await prisma.deliveryRequest.findMany({
      where: {
        clientCompanyId: ctx.company.id,
      },
      include: {
        stops: {
          include: {
            address: true,
            endClientCompany: true,
            deliveryStop: {
              include: {
                delivery: true,
              },
            },
          },
          orderBy: {
            sequence: "asc",
          },
        },
        clientCompany: true,
        deliveryCompany: true,
      },
      orderBy: {
        date: "desc",
      },
    });

    return requests;
  });
}
