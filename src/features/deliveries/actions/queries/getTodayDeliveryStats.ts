"use server";

import prisma from "@/lib/database/prisma";
import { withAuth } from "@/lib/permissions";
import { startOfToday } from "@/lib/time";

type OngoingDelivery = {
  id: string;
  number: string;
  deliveryStatus: string;
  stopsCount: number;
  completedStopsCount: number;
};

type DeliveryRequestStats = {
  clientsCount: number;
  endClientsCount: number;
};

type TodayDeliverySummary = {
  id: string;
  number: string;
  deliveryStatus: string;
  driverName: string | null;
  stopsCount: number;
  completedStopsCount: number;
};

type TodayDeliveryStats = {
  ongoingDelivery: OngoingDelivery | null;
  deliveryRequestStats: DeliveryRequestStats | null;
  todayDeliveries: TodayDeliverySummary[];
};

export async function getTodayDeliveryStats(): Promise<TodayDeliveryStats> {
  return withAuth<TodayDeliveryStats>(async (ctx, policies) => {
    // Only for delivery companies
    if (!policies.isDeliveryCompany()) {
      return {
        ongoingDelivery: null,
        deliveryRequestStats: null,
        todayDeliveries: [],
      };
    }

    const today = startOfToday();

    // Build where clause - non-admin members can only see their own deliveries
    const deliveryWhere: any = {
      deliveryCompanyId: ctx.company.id,
      date: today,
    };

    if (!policies.isAdmin() && !policies.isManager()) {
      deliveryWhere.driverId = ctx.user.id;
    }

    // Get all deliveries for today
    const todayDeliveries = await prisma.delivery.findMany({
      where: deliveryWhere,
      include: {
        driver: {
          select: {
            firstName: true,
            lastName: true,
          },
        },
        stops: {
          select: {
            id: true,
            status: true,
          },
        },
      },
      orderBy: {
        createdAt: "asc",
      },
    });

    // Check for ongoing delivery today (for backward compatibility)
    const ongoingDelivery = todayDeliveries.find(
      (d) => d.deliveryStatus === "IN_PROGRESS",
    );

    const todayDeliveriesSummary: TodayDeliverySummary[] = todayDeliveries.map(
      (delivery) => ({
        id: delivery.id,
        number: delivery.number,
        deliveryStatus: delivery.deliveryStatus,
        driverName: delivery.driver
          ? `${delivery.driver.firstName} ${delivery.driver.lastName}`
          : null,
        stopsCount: delivery.stops.length,
        completedStopsCount: delivery.stops.filter(
          (s) => s.status === "DELIVERED",
        ).length,
      }),
    );

    // If there's an ongoing delivery, return it for backward compatibility
    if (ongoingDelivery) {
      return {
        ongoingDelivery: {
          id: ongoingDelivery.id,
          number: ongoingDelivery.number,
          deliveryStatus: ongoingDelivery.deliveryStatus,
          stopsCount: ongoingDelivery.stops.length,
          completedStopsCount: ongoingDelivery.stops.filter(
            (s) => s.status === "DELIVERED",
          ).length,
        },
        deliveryRequestStats: null,
        todayDeliveries: todayDeliveriesSummary,
      };
    }

    // If there are scheduled deliveries, don't show delivery request stats
    if (todayDeliveries.length > 0) {
      return {
        ongoingDelivery: null,
        deliveryRequestStats: null,
        todayDeliveries: todayDeliveriesSummary,
      };
    }

    // No ongoing delivery and no scheduled deliveries
    // Non-admin members don't see delivery request stats (administrative data)
    if (!policies.isAdmin() && !policies.isManager()) {
      return {
        ongoingDelivery: null,
        deliveryRequestStats: null,
        todayDeliveries: [],
      };
    }

    // Get delivery request stats for today (admin/manager only)
    const deliveryRequests = await prisma.deliveryRequest.findMany({
      where: {
        deliveryCompanyId: ctx.company.id,
        date: today,
      },
      include: {
        clientCompany: {
          select: {
            id: true,
            name: true,
          },
        },
        stops: {
          select: {
            endClientId: true,
          },
        },
      },
    });

    if (deliveryRequests.length === 0) {
      return {
        ongoingDelivery: null,
        deliveryRequestStats: null,
        todayDeliveries: [],
      };
    }

    // Count unique clients
    const uniqueClientIds = new Set(
      deliveryRequests.map((r) => r.clientCompanyId),
    );

    // Count unique end clients across all requests
    const uniqueEndClientIds = new Set(
      deliveryRequests.flatMap((r) => r.stops.map((s) => s.endClientId)),
    );

    return {
      ongoingDelivery: null,
      deliveryRequestStats: {
        clientsCount: uniqueClientIds.size,
        endClientsCount: uniqueEndClientIds.size,
      },
      todayDeliveries: [],
    };
  });
}
