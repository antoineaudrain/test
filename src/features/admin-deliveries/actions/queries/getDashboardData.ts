"use server";

import type { Prisma } from "@/generated/prisma";
import prisma from "@/lib/database/prisma";
import { withAuth } from "@/lib/permissions";
import { dateStringToDate, Time } from "@/lib/time";

type DeliveryWithRelations = Prisma.DeliveryGetPayload<{
  include: {
    driver: true;
    vehicle: true;
    stops: true;
    clientCompany: true;
  };
}>;

export type DashboardRequestStats = {
  clientsCount: number;
  endClientsCount: number;
  stopsCount: number;
};

export type DashboardData = {
  today: {
    deliveries: DeliveryWithRelations[];
    requests: DashboardRequestStats | null;
  };
  tomorrow: {
    requests: DashboardRequestStats | null;
  };
};

export async function getDashboardData(): Promise<DashboardData> {
  return withAuth<DashboardData>(async (ctx, policies) => {
    // 1. Validate permissions
    policies.canViewAdminDeliveriesPage();

    // 2. Get today and tomorrow dates
    const today = Time().format("YYYY-MM-DD");
    const tomorrow = Time().add(1, "day").format("YYYY-MM-DD");

    const todayDate = dateStringToDate(today);
    const tomorrowDate = dateStringToDate(tomorrow);

    // 3. Get today's deliveries
    const todayDeliveries = await prisma.delivery.findMany({
      where: {
        deliveryCompanyId: ctx.company.id,
        date: todayDate,
      },
      include: {
        driver: true,
        vehicle: true,
        stops: true,
        clientCompany: true,
      },
      orderBy: {
        createdAt: "desc",
      },
    });

    // 4. Get today's request stats
    const todayRequests = await prisma.deliveryRequest.findMany({
      where: {
        deliveryCompanyId: ctx.company.id,
        date: todayDate,
      },
      include: {
        stops: {
          include: {
            endClientCompany: true,
          },
        },
        clientCompany: true,
      },
    });

    const todayRequestStats: DashboardRequestStats | null =
      todayRequests.length > 0
        ? {
            clientsCount: new Set(todayRequests.map((r) => r.clientCompanyId))
              .size,
            endClientsCount: new Set(
              todayRequests.flatMap((r) => r.stops.map((s) => s.endClientId)),
            ).size,
            stopsCount: todayRequests.reduce(
              (sum, r) => sum + r.stops.length,
              0,
            ),
          }
        : null;

    // 5. Get tomorrow's request stats
    const tomorrowRequests = await prisma.deliveryRequest.findMany({
      where: {
        deliveryCompanyId: ctx.company.id,
        date: tomorrowDate,
      },
      include: {
        stops: {
          include: {
            endClientCompany: true,
          },
        },
        clientCompany: true,
      },
    });

    const tomorrowRequestStats: DashboardRequestStats | null =
      tomorrowRequests.length > 0
        ? {
            clientsCount: new Set(
              tomorrowRequests.map((r) => r.clientCompanyId),
            ).size,
            endClientsCount: new Set(
              tomorrowRequests.flatMap((r) =>
                r.stops.map((s) => s.endClientId),
              ),
            ).size,
            stopsCount: tomorrowRequests.reduce(
              (sum, r) => sum + r.stops.length,
              0,
            ),
          }
        : null;

    // 6. Return dashboard data
    return {
      today: {
        deliveries: todayDeliveries,
        requests: todayRequestStats,
      },
      tomorrow: {
        requests: tomorrowRequestStats,
      },
    };
  });
}
