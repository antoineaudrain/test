"use server";

import type { DeliveryWithRelations } from "@/features/deliveries/types";
import { DeliveryStatus } from "@/generated/prisma";
import prisma from "@/lib/database/prisma";
import { withAuth } from "@/lib/permissions";
import { dateStringToDate } from "@/lib/time";

export type ListDeliveriesByDateRangeReturn = DeliveryWithRelations<{
  deliveryCompany: true;
  driver: true;
  vehicle: true;
  stops: {
    include: {
      endClientCompany: {
        include: {
          address: true;
        };
      };
    };
  };
}>[];

export type ListDeliveriesByDateRangeProps = {
  dateFrom: string;
  dateTo: string;
};

export async function listDeliveriesByDateRange({
  dateFrom,
  dateTo,
}: ListDeliveriesByDateRangeProps) {
  return withAuth<ListDeliveriesByDateRangeReturn>(async (ctx, policies) => {
    const startDate = dateStringToDate(dateFrom);
    const endDate = dateStringToDate(dateTo);

    // Build where clause based on user role
    const whereClause = {
      deliveryStatus: DeliveryStatus.COMPLETED,
      date: {
        gte: startDate,
        lte: endDate,
      },
      // Client companies can only see deliveries with their end clients
      ...(policies.isClientCompany() && {
        stops: {
          some: {
            endClientCompany: {
              parentId: ctx.company.id,
            },
          },
        },
      }),
      // Delivery companies can see all their deliveries
      ...(policies.isDeliveryCompany() && {
        deliveryCompanyId: ctx.company.id,
      }),
    };

    const deliveries = await prisma.delivery.findMany({
      where: whereClause,
      include: {
        deliveryCompany: true,
        driver: true,
        vehicle: true,
        stops: {
          include: {
            endClientCompany: {
              include: {
                address: true,
              },
            },
          },
          // Filter stops to only include the client company's end clients
          ...(policies.isClientCompany() && {
            where: {
              endClientCompany: {
                parentId: ctx.company.id,
              },
            },
          }),
          orderBy: {
            sequence: "asc",
          },
        },
      },
      orderBy: { date: "asc" },
    });

    policies.canViewDeliveries(deliveries);

    return deliveries;
  });
}
