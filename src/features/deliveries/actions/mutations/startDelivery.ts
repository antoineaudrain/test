"use server";

import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { DeliveryStatus, StopStatus } from "@/generated/prisma";
import prisma from "@/lib/database/prisma";
import { withAuth } from "@/lib/permissions";
import { dateStringToDate, now, Time } from "@/lib/time";

type StartDeliveryProps = {
  deliveryId: string;
};

export async function startDelivery({
  deliveryId,
}: StartDeliveryProps): Promise<void> {
  return withAuth<void>(async (ctx, policies) => {
    const currentTime = Time();
    const _year = currentTime.format("YY");

    const delivery = await prisma.delivery.findFirst({
      where: {
        id: deliveryId,
        OR: [
          { deliveryCompanyId: ctx.company.id },
          { clientCompanyId: ctx.company.id },
        ],
      },
      include: {
        stops: {
          where: { status: StopStatus.PLANNED },
          orderBy: { sequence: "asc" },
          take: 1,
        },
      },
    });

    if (!delivery) throw new Error("Delivery not found");
    policies.canStartDelivery(delivery);

    const upcomingStop = delivery.stops[0];
    if (!upcomingStop) throw new Error("No upcoming stop found");

    // Check cutoff time - drivers can only start after cutoff
    const clientSettings = await prisma.clientSettings.findUnique({
      where: { clientCompanyId: delivery.clientCompanyId },
    });

    if (clientSettings?.cutoffTime) {
      const [hours, minutes] = clientSettings.cutoffTime.split(":").map(Number);

      // Create cutoff datetime for the delivery date
      const deliveryDate = Time(delivery.date).format("YYYY-MM-DD");
      const deliveryDateObj = dateStringToDate(deliveryDate);
      const cutoffDateTime = Time(deliveryDateObj)
        .hour(hours)
        .minute(minutes)
        .second(0);

      // Check if current time is before cutoff
      if (currentTime.isBefore(cutoffDateTime)) {
        const timeUntilCutoff = cutoffDateTime.diff(currentTime, "minute");
        throw new Error(
          `Vous ne pouvez pas démarrer cette livraison avant l'heure limite (${clientSettings.cutoffTime}). Temps restant: ${timeUntilCutoff} minute${timeUntilCutoff > 1 ? "s" : ""}.`,
        );
      }
    }

    await prisma.delivery.update({
      where: { id: deliveryId },
      data: {
        deliveryStatus: DeliveryStatus.IN_PROGRESS,
        startedAt: now(),
        stops: {
          update: {
            where: { id: upcomingStop.id },
            data: { status: StopStatus.EN_ROUTE },
          },
        },
      },
    });

    revalidatePath("/deliveries");
    revalidatePath(`/deliveries/${deliveryId}`);
    revalidatePath(`/deliveries/${deliveryId}/stops/${upcomingStop.id}`);
    redirect(`/deliveries/${deliveryId}/stops/${upcomingStop.id}`);
  });
}
