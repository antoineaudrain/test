"use server";

import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { canModifyRequest } from "@/features/delivery-requests/actions/queries/canModifyRequest";
import {
  type UpdateDeliveryRequestInput,
  UpdateDeliveryRequestSchema,
} from "@/features/delivery-requests/schemas/deliveryRequest";
import prisma from "@/lib/database/prisma";
import { withAuth } from "@/lib/permissions";

type UpdateDeliveryRequestProps = {
  input: UpdateDeliveryRequestInput;
};

export async function updateDeliveryRequest({
  input,
}: UpdateDeliveryRequestProps): Promise<void> {
  return withAuth<void>(async (ctx, policies) => {
    // 1. Validate permissions
    policies.canUpdateDeliveryRequest();

    // 2. Validate input
    const validatedInput = UpdateDeliveryRequestSchema.parse(input);

    // 3. Get existing request
    const existingRequest = await prisma.deliveryRequest.findUnique({
      where: { id: validatedInput.requestId },
      include: {
        stops: {
          include: {
            deliveryStop: {
              include: {
                delivery: true,
              },
            },
          },
        },
      },
    });

    if (!existingRequest) {
      throw new Error("Delivery request not found");
    }

    // 4. Check ownership
    if (existingRequest.clientCompanyId !== ctx.company.id) {
      throw new Error("Can only update own delivery requests");
    }

    // 5. Check cutoff time
    const modifyCheck = await canModifyRequest({
      clientCompanyId: ctx.company.id,
      requestDate: existingRequest.date.toISOString().split("T")[0],
    });

    if (!modifyCheck.canModify) {
      throw new Error(
        `Cannot update request: cutoff time (${modifyCheck.cutoffTime}) has passed`,
      );
    }

    // 6. Prepare update data
    const updateData: any = {
      notes: validatedInput.notes,
    };

    // 7. Update stops if provided
    if (validatedInput.stops) {
      const existingStopIds = new Set(existingRequest.stops.map((s) => s.id));
      const inputStopIds = new Set(
        validatedInput.stops.filter((s) => s.id).map((s) => s.id!),
      );

      // Stops to delete (in existing but not in input)
      const stopsToDelete = existingRequest.stops.filter(
        (s) => !inputStopIds.has(s.id),
      );

      // Prevent deleting stops that are linked to deliveries
      const stopsWithDeliveries = stopsToDelete.filter(
        (stop) => stop.deliveryStopId !== null,
      );

      if (stopsWithDeliveries.length > 0) {
        throw new Error(
          "Cannot remove stops that are linked to deliveries. You can only add new stops.",
        );
      }

      // Perform updates sequentially
      // Delete stops not in input
      if (stopsToDelete.length > 0) {
        await prisma.deliveryRequestStop.deleteMany({
          where: {
            id: { in: stopsToDelete.map((s) => s.id) },
          },
        });
      }

      // Update or create stops
      for (const stop of validatedInput.stops) {
        if (stop.id && existingStopIds.has(stop.id)) {
          // Update existing stop
          await prisma.deliveryRequestStop.update({
            where: { id: stop.id },
            data: {
              sequence: stop.sequence,
              type: stop.type,
              notes: stop.notes,
              addressId: stop.addressId,
              endClientId: stop.endClientId,
            },
          });
        } else {
          // Create new stop
          await prisma.deliveryRequestStop.create({
            data: {
              sequence: stop.sequence,
              type: stop.type,
              notes: stop.notes,
              addressId: stop.addressId,
              endClientId: stop.endClientId,
              requestId: validatedInput.requestId,
            },
          });
        }
      }

      // Update request notes
      await prisma.deliveryRequest.update({
        where: { id: validatedInput.requestId },
        data: updateData,
      });
    } else {
      // Just update notes
      await prisma.deliveryRequest.update({
        where: { id: validatedInput.requestId },
        data: updateData,
      });
    }

    // 8. Revalidate and redirect
    revalidatePath("/delivery-requests");
    revalidatePath(`/delivery-requests/${validatedInput.requestId}`);
    redirect("/delivery-requests");
  });
}
