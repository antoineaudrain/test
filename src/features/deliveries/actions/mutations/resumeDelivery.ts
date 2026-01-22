"use server";

import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { StopStatus } from "@/generated/prisma";
import prisma from "@/lib/database/prisma";
import { withAuth } from "@/lib/permissions";

type ResumeDeliveryProps = {
  deliveryId: string;
};

export async function resumeDelivery({
  deliveryId,
}: ResumeDeliveryProps): Promise<void> {
  return withAuth<void>(async (ctx, policies) => {
    const delivery = await prisma.delivery.findUnique({
      where: {
        id: deliveryId,
        deliveryCompanyId: ctx.company.id,
      },
      include: {
        stops: {
          orderBy: {
            sequence: "asc",
          },
        },
      },
    });

    if (!delivery) throw new Error("Delivery not found");
    policies.canResumeDelivery(delivery);

    const ongoingStop = delivery.stops.find(
      (stop) => stop.status === StopStatus.EN_ROUTE,
    );
    if (ongoingStop) {
      redirect(`/deliveries/${deliveryId}/stops/${ongoingStop.id}`);
    }

    const upcomingStop = delivery.stops.find(
      (stop) => stop.status === StopStatus.PLANNED,
    );
    if (!upcomingStop) {
      redirect(`/deliveries/${deliveryId}/completed`);
    }

    await prisma.stop.update({
      where: {
        id: upcomingStop.id,
        delivery: {
          id: deliveryId,
        },
      },
      data: {
        status: StopStatus.EN_ROUTE,
      },
    });

    revalidatePath("/deliveries");
    revalidatePath(`/deliveries/${deliveryId}`);
    revalidatePath(`/deliveries/${deliveryId}/stops/${upcomingStop.id}`);
    redirect(`/deliveries/${deliveryId}/stops/${upcomingStop.id}`);
  });
}
