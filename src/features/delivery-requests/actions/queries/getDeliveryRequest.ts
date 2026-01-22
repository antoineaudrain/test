"use server";

import type { DeliveryRequestWithStops } from "@/features/delivery-requests/types";
import prisma from "@/lib/database/prisma";
import { withAuth } from "@/lib/permissions";

export async function getDeliveryRequest({
  requestId,
}: {
  requestId: string;
}): Promise<DeliveryRequestWithStops | null> {
  return withAuth<DeliveryRequestWithStops | null>(
    async (ctx, policies) => {
      // 1. Get the delivery request
      const request = await prisma.deliveryRequest.findUnique({
        where: { id: requestId },
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
          deliveryCompany: true,
        },
      });

      if (!request) {
        return null;
      }

      // 2. Validate permissions
      policies.canViewDeliveryRequest(request);

      return request;
    },
  );
}
