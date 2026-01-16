"use server";

import { startNextStop } from "@/features/stops/actions/mutations/getNextStop";
import {
  type FailStopInput,
  FailStopSchema,
} from "@/features/stops/schemas/failStop";
import { StopStatus } from "@/generated/prisma";
import prisma from "@/lib/database/prisma";
import { withAuth } from "@/lib/permissions";
import { now } from "@/lib/time";

type FailStopProps = {
  deliveryId: string;
  stopId: string;
  input: FailStopInput;
};

export async function failStop({
  deliveryId,
  stopId,
  input,
}: FailStopProps): Promise<void> {
  return withAuth<void>(async (ctx, _policies) => {
    const { imageUrl, driverNotes } = FailStopSchema.parse(input);

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
    // policies.canFailStop(stop);

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
        status: StopStatus.FAILED,
        driverNotes,
        imageUrl,
        completedAt: now(),
        // updatedAt is handled automatically by Prisma @updatedAt
      },
    });

    return startNextStop({ deliveryId });
  });
}
