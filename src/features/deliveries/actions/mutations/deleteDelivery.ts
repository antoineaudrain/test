"use server";

import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import prisma from "@/lib/database/prisma";
import { withAuth } from "@/lib/permissions";

type DeleteDeliveryProps = {
  deliveryId: string;
};

export async function deleteDelivery({ deliveryId }: DeleteDeliveryProps) {
  return withAuth(async (_ctx, _policies) => {
    const delivery = await prisma.delivery.findUnique({
      where: {
        id: deliveryId,
      },
    });

    if (!delivery) throw new Error("Delivery batch not found");

    await prisma.delivery.delete({
      where: {
        id: deliveryId,
      },
    });

    revalidatePath("/deliveries");
    redirect("/deliveries");
  });
}
