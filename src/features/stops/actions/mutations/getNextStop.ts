import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { StopStatus } from "@/generated/prisma";
import prisma from "@/lib/database/prisma";
import { withAuth } from "@/lib/permissions";

type StartNextStopProps = {
  deliveryId: string;
};

export async function startNextStop({ deliveryId }: StartNextStopProps) {
  return withAuth(async (ctx, policies) => {
    const delivery = await prisma.delivery.findUnique({
      where: {
        id: deliveryId,
        OR: [{ deliveryCompanyId: ctx.company.id }],
      },
      include: {
        driver: true,
        stops: {
          where: {
            status: StopStatus.PLANNED,
          },
          include: {
            endClientCompany: true,
          },
          orderBy: {
            sequence: "asc",
          },
          take: 1,
        },
      },
    });

    if (!delivery) throw new Error("Delivery not found");
    policies.canViewDelivery(delivery);

    const nextStop = delivery.stops[0];

    if (!nextStop) {
      redirect(`/deliveries/${deliveryId}/completed`);
    }

    await prisma.stop.update({
      where: { id: nextStop.id },
      data: {
        status: StopStatus.EN_ROUTE,
      },
    });

    revalidatePath("/deliveries");
    revalidatePath(`/deliveries/${deliveryId}`);
    revalidatePath(`/deliveries/${deliveryId}/stops/${nextStop.id}`);
    redirect(`/deliveries/${deliveryId}/stops/${nextStop.id}`);
  });
}
