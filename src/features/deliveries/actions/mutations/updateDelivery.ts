"use server";

import { revalidatePath } from "next/cache";
import {
  type UpdateDeliveryFormInput,
  UpdateDeliveryFormSchema,
} from "@/features/deliveries/schema/updateDelivery";
import prisma from "@/lib/database/prisma";
import { withAuth } from "@/lib/permissions";

type UpdateDeliveryProps = {
  deliveryId: string;
  input: UpdateDeliveryFormInput;
};

export async function updateDelivery({
  deliveryId,
  input,
}: UpdateDeliveryProps) {
  return withAuth<void>(async (_ctx, _policies) => {
    const delivery = await prisma.delivery.findUnique({
      where: { id: deliveryId },
      include: {
        stops: {
          include: {
            endClientCompany: {
              include: {
                address: true,
              },
            },
          },
        },
      },
    });

    if (!delivery) throw new Error("Delivery not found");

    const { stops, ...deliveryData } = UpdateDeliveryFormSchema.parse(input);

    const stopsData = stops
      .filter((stop) => stop.selected && stop.type)
      .map((stop) => {
        const existingStop = delivery.stops.find(
          (s) => s.endClientCompany.id === stop.companyId,
        );
        if (!existingStop?.endClientCompany?.addressId)
          throw new Error(
            `Stop not found or missing address for companyId ${stop.companyId}`,
          );
        return {
          sequence: stop.sequence,
          type: stop.type as "PICKUP" | "DROPOFF" | "BOTH",
          notes: stop.notes,
          endClientId: stop.companyId,
          addressId: existingStop.endClientCompany.addressId,
        };
      });

    if (!stopsData.length)
      throw new Error("At least one stop must be selected");

    await prisma.delivery.update({
      where: { id: deliveryId },
      data: {
        notes: deliveryData.notes,
        stops: {
          deleteMany: {},
          create: stopsData,
        },
      },
    });

    revalidatePath("/deliveries");
    revalidatePath(`/deliveries/${deliveryId}`);
  });
}
