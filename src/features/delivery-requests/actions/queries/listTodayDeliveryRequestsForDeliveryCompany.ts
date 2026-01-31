"use server";

import type { DeliveryRequestWithStops } from "@/features/delivery-requests/types";
import prisma from "@/lib/database/prisma";
import { withAuth } from "@/lib/permissions";
import { dateStringToDate, todayDateString } from "@/lib/time";

export async function listTodayDeliveryRequestsForDeliveryCompany(): Promise<
  DeliveryRequestWithStops[]
> {
  return withAuth<DeliveryRequestWithStops[]>(async (ctx, policies) => {
    // Only delivery companies can call this
    if (!policies.isDeliveryCompany()) {
      throw new Error("Only delivery companies can view delivery requests");
    }

    // Get today's date string and convert to Date
    const today = todayDateString();
    const todayDate = dateStringToDate(today);

    // Get requests where the delivery company matches current company
    const requests = await prisma.deliveryRequest.findMany({
      where: {
        deliveryCompanyId: ctx.company.id,
        date: todayDate,
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
        deliveryCompany: true,
        clientCompany: true,
      },
      orderBy: {
        clientCompany: {
          name: "asc",
        },
      },
    });

    return requests;
  });
}
