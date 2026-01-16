"use server";

import type { StopWithRelations } from "@/features/stops/types";
import prisma from "@/lib/database/prisma";
import { withAuth } from "@/lib/permissions";

type GetStopReturn = StopWithRelations<{
  delivery: true;
  address: true;
  endClientCompany: true;
}> | null;

type GetStopProps = {
  deliveryId: string;
  stopId: string;
};

export async function getStop({
  deliveryId,
  stopId,
}: GetStopProps): Promise<GetStopReturn> {
  return withAuth<GetStopReturn>(async (ctx, policies) => {
    const stop = await prisma.stop.findUnique({
      where: {
        id: stopId,
        delivery: {
          id: deliveryId,
          OR: [
            { deliveryCompanyId: ctx.company.id },
            { clientCompanyId: ctx.company.id },
          ],
        },
      },
      include: {
        delivery: true,
        address: true,
        endClientCompany: true,
      },
    });

    if (!stop) throw new Error("Stop not found");
    policies.canViewStop(stop);

    return stop;
  });
}
