"use server";

import { startNextStop } from "@/features/stops/actions/mutations/getNextStop";
import {
  type CompleteStopInput,
  CompleteStopSchema,
} from "@/features/stops/schemas/completeStop";
import { StopStatus } from "@/generated/prisma";
import prisma from "@/lib/database/prisma";
import { withAuth } from "@/lib/permissions";
import { now } from "@/lib/time";

type CompleteStopProps = {
  deliveryId: string;
  stopId: string;
  input: CompleteStopInput;
};

export async function completeStop({
  deliveryId,
  stopId,
  input,
}: CompleteStopProps): Promise<void> {
  return withAuth<void>(async (ctx, _policies) => {
    const { imageUrl, driverNotes } = CompleteStopSchema.parse(input);

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
    });

    if (!stop) throw new Error("Stop not found");
    // policies.canCompleteStop(stop);

    await prisma.stop.update({
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
      data: {
        status: StopStatus.DELIVERED,
        driverNotes,
        imageUrl,
        completedAt: now(),
        // updatedAt is handled automatically by Prisma @updatedAt
      },
    });

    return startNextStop({ deliveryId });
  });
}
