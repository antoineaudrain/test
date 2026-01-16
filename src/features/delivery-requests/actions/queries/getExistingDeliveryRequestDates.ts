"use server";

import prisma from "@/lib/database/prisma";
import { withAuth } from "@/lib/permissions";
import { startOfToday } from "@/lib/time";

export async function getExistingDeliveryRequestDates(): Promise<Date[]> {
  return withAuth<Date[]>(async (ctx) => {
    const requests = await prisma.deliveryRequest.findMany({
      where: {
        clientCompanyId: ctx.company.id,
        date: {
          gte: startOfToday(),
        },
      },
      select: {
        date: true,
      },
    });

    return requests.map((r) => r.date);
  });
}
