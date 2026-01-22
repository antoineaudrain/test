"use server";

import type { DeliveryWithRelations } from "@/features/deliveries/types";
import prisma from "@/lib/database/prisma";
import { withAuth } from "@/lib/permissions";

export type ListDeliveryReturn = DeliveryWithRelations<{
  deliveryCompany: true;
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

    // Filter by company based on company type
    if (policies.isDeliveryCompany()) {
      whereClause.deliveryCompanyId = ctx.company.id;

      // Non-admin members can only see their own deliveries
      if (!policies.isAdmin() && !policies.isManager()) {
        whereClause.driverId = ctx.user.id;
      }
    } else if (policies.isClientCompany()) {
      // For client companies, filter deliveries that have stops going to their end clients
      whereClause.stops = {
        some: {
          endClientCompany: {
            parentId: ctx.company.id,
          },
        },
      };
    }

    const deliveries = await prisma.delivery.findMany({
      where: whereClause,
      include: {
        deliveryCompany: true,
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
