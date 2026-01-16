"use server";

import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import {
  type CompleteDeliveryFormInput,
  CompleteDeliveryFormSchema,
} from "@/features/deliveries/schema/completeDelivery";
import { DeliveryStatus } from "@/generated/prisma";
import prisma from "@/lib/database/prisma";
import { withAuth } from "@/lib/permissions";

type CompleteDeliveryProps = {
  deliveryId: string;
  input: CompleteDeliveryFormInput;
};

export async function completeDelivery({
  deliveryId,
  input,
}: CompleteDeliveryProps) {
  return withAuth<void>(async (_ctx, _policies) => {
    const delivery = await prisma.delivery.findUnique({
      where: { id: deliveryId },
      include: {
        clientCompany: true,
      },
    });

    if (!delivery) throw new Error("Delivery not found");

    const { driverNotes, finishedAt } = CompleteDeliveryFormSchema.parse(input);

    await prisma.delivery.update({
      where: { id: deliveryId },
      data: {
        driverNotes: driverNotes,
        deliveryStatus: DeliveryStatus.COMPLETED,
        finishedAt,
      },
    });

    revalidatePath("/deliveries");
    revalidatePath(`/deliveries/${deliveryId}`);
    redirect(`/deliveries/${deliveryId}`);
  });
}
