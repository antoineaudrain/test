"use server";

import {
  type PastDeliveriesFilters,
  PastDeliveriesFiltersSchema,
} from "@/features/admin-deliveries/schemas/saveDeliveries";
import type { DeliveryStatus, Prisma } from "@/generated/prisma";
import prisma from "@/lib/database/prisma";
import { withAuth } from "@/lib/permissions";
import { dateStringToDate, Time } from "@/lib/time";

type DeliveryWithRelations = Prisma.DeliveryGetPayload<{
  include: {
    driver: true;
    vehicle: true;
    stops: true;
  };
}>;

export type PastDeliveriesResult = {
  deliveries: DeliveryWithRelations[];
  pagination: {
    page: number;
    pageSize: number;
    total: number;
    totalPages: number;
  };
};

export async function getPastDeliveries(
  filters: PastDeliveriesFilters,
): Promise<PastDeliveriesResult> {
  return withAuth<PastDeliveriesResult>(async (ctx, policies) => {
    // 1. Validate permissions
    policies.canViewAdminDeliveriesPage();

    // 2. Validate filters
    const validatedFilters = PastDeliveriesFiltersSchema.parse(filters);

    // 3. Build where clause
    const today = Time().startOf("day");

    // Build date filter
    const dateFilter: {
      lt?: Date;
      gte?: Date;
      lte?: Date;
    } = {
      lt: dateStringToDate(today.format("YYYY-MM-DD")),
    };

    if (validatedFilters.dateFrom) {
      dateFilter.gte = dateStringToDate(validatedFilters.dateFrom);
    }

    if (validatedFilters.dateTo) {
      dateFilter.lte = dateStringToDate(validatedFilters.dateTo);
    }

    const where: Prisma.DeliveryWhereInput = {
      deliveryCompanyId: ctx.company.id,
      date: dateFilter,
    };

    if (validatedFilters.driverId) {
      where.driverId = validatedFilters.driverId;
    }

    if (validatedFilters.vehicleId) {
      where.vehicleId = validatedFilters.vehicleId;
    }

    if (validatedFilters.status) {
      where.deliveryStatus = validatedFilters.status as DeliveryStatus;
    }

    // 4. Get total count
    const total = await prisma.delivery.count({ where });

    // 5. Get paginated deliveries
    const deliveries = await prisma.delivery.findMany({
      where,
      include: {
        driver: true,
        vehicle: true,
        stops: true,
      },
      orderBy: {
        date: "desc",
      },
      skip: (validatedFilters.page - 1) * validatedFilters.pageSize,
      take: validatedFilters.pageSize,
    });

    // 6. Calculate pagination
    const totalPages = Math.ceil(total / validatedFilters.pageSize);

    return {
      deliveries,
      pagination: {
        page: validatedFilters.page,
        pageSize: validatedFilters.pageSize,
        total,
        totalPages,
      },
    };
  });
}
