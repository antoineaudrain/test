"use server";

import type { Delivery } from "@/features/deliveries/types";
import type { DeliveryRequestStopWithDetails } from "@/features/delivery-requests/types";
import prisma from "@/lib/database/prisma";
import { withAuth } from "@/lib/permissions";
import { dateStringToDate } from "@/lib/time";

export type DeliveryCreationData = {
  date: string;
  endClients: Array<{
    id: string;
    name: string;
    address: {
      id: string;
      formattedAddress: string;
      latitude: number | null;
      longitude: number | null;
    };
    requestStops: DeliveryRequestStopWithDetails[];
  }>;
  existingDeliveries: Array<
    Delivery & {
      stops: Array<{
        id: string;
        sequence: number;
        type: string;
        endClientId: string;
        sourceRequestStopId?: string;
      }>;
    }
  >;
  drivers: Array<{
    id: string;
    firstName: string;
    lastName: string;
    vehicleId: string | null;
  }>;
  summary: {
    totalRequests: number;
    totalStops: number;
    assignedStops: number;
    unassignedStops: number;
  };
};

export async function getDeliveryCreationData(
  date: string,
): Promise<DeliveryCreationData> {
  return withAuth<DeliveryCreationData>(async (ctx, policies) => {
    // 1. Validate permissions
    policies.canViewDeliveryCreationPage();

    // 2. Parse date
    const dateObj = dateStringToDate(date);

    // 3. Get all delivery request stops for this date
    const requestStops = await prisma.deliveryRequestStop.findMany({
      where: {
        request: {
          deliveryCompanyId: ctx.company.id,
          date: dateObj,
        },
      },
      include: {
        address: true,
        endClientCompany: true,
        deliveryStop: {
          include: {
            delivery: true,
          },
        },
        request: {
          include: {},
        },
      },
      orderBy: [{ endClientId: "asc" }, { sequence: "asc" }],
    });

    // 4. Group stops by end client
    const endClientsMap = new Map<
      string,
      {
        id: string;
        name: string;
        address: {
          id: string;
          formattedAddress: string;
          latitude: number | null;
          longitude: number | null;
        };
        requestStops: DeliveryRequestStopWithDetails[];
      }
    >();

    for (const stop of requestStops) {
      if (!endClientsMap.has(stop.endClientId)) {
        endClientsMap.set(stop.endClientId, {
          id: stop.endClientCompany.id,
          name: stop.endClientCompany.name,
          address: {
            id: stop.address.id,
            formattedAddress: stop.address.formattedAddress,
            latitude: stop.address.latitude,
            longitude: stop.address.longitude,
          },
          requestStops: [],
        });
      }
      endClientsMap.get(stop.endClientId)?.requestStops.push(stop);
    }

    const endClients = Array.from(endClientsMap.values());

    // 5. Get existing deliveries for this date
    const existingDeliveries = await prisma.delivery.findMany({
      where: {
        deliveryCompanyId: ctx.company.id,
        date: dateObj,
      },
      include: {
        driver: true,
        vehicle: true,
        stops: {
          include: {
            sourceRequestStop: true,
          },
          orderBy: {
            sequence: "asc",
          },
        },
      },
      orderBy: {
        createdAt: "asc",
      },
    });

    // 6. Get drivers with their vehicles
    const drivers = await prisma.user.findMany({
      where: {
        companyId: ctx.company.id,
        role: { in: ["ADMIN", "MANAGER", "MEMBER"] },
      },
      select: {
        id: true,
        firstName: true,
        lastName: true,
        vehicleId: true,
      },
      orderBy: [{ firstName: "asc" }, { lastName: "asc" }],
    });

    // 7. Calculate summary stats
    const totalStops = requestStops.length;
    const assignedStops = requestStops.filter((s) => s.deliveryStopId).length;
    const totalRequests = new Set(requestStops.map((s) => s.requestId)).size;

    return {
      date,
      endClients,
      existingDeliveries: existingDeliveries.map((delivery) => ({
        ...delivery,
        stops: delivery.stops.map((stop) => ({
          id: stop.id,
          sequence: stop.sequence,
          type: stop.type,
          endClientId: stop.endClientId,
          sourceRequestStopId: stop.sourceRequestStop?.id,
        })),
      })),
      drivers,
      summary: {
        totalRequests,
        totalStops,
        assignedStops,
        unassignedStops: totalStops - assignedStops,
      },
    };
  });
}
