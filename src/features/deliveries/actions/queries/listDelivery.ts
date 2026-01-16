"use server";

import type { DeliveryWithRelations } from "@/features/deliveries/types";
import prisma from "@/lib/database/prisma";
import { withAuth } from "@/lib/permissions";

export type ListDeliveryReturn = DeliveryWithRelations<{
  deliveryCompany: true;
  clientCompany: true;
  driver: true;
  vehicle: true;
  stops: {
    include: {
      endClientCompany: true;
    };
  };
}>[];

export async function listDelivery() {
  return withAuth<ListDeliveryReturn>(async (ctx, policies) => {
    // Build where clause based on user role
    const whereClause: any = {};

    // Non-admin members can only see their own deliveries
    if (
      policies.isDeliveryCompany() &&
      !policies.isAdmin() &&
      !policies.isManager()
    ) {
      whereClause.driverId = ctx.user.id;
    }

    const deliveries = await prisma.delivery.findMany({
      where: whereClause,
      include: {
        deliveryCompany: true,
        clientCompany: true,
        driver: true,
        vehicle: true,
        stops: {
          include: {
            endClientCompany: true,
          },
        },
      },
    });

    policies.canViewDeliveries(deliveries);

    return deliveries;
  });
}
