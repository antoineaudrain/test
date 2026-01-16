"use server";

import prisma from "@/lib/database/prisma";
import { withAuth } from "@/lib/permissions";
import { startOfToday } from "@/lib/time";

export async function getExistingDeliveryDates(): Promise<Date[]> {
  return withAuth<Date[]>(async (ctx) => {
    const deliveries = await prisma.delivery.findMany({
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

    return deliveries.map((d) => d.date);
  });
}
