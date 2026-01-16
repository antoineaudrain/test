"use server";

import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { canModifyRequest } from "@/features/delivery-requests/actions/queries/canModifyRequest";
import {
  type CancelDeliveryRequestInput,
  CancelDeliveryRequestSchema,
} from "@/features/delivery-requests/schemas/deliveryRequest";
import prisma from "@/lib/database/prisma";
import { withAuth } from "@/lib/permissions";

type CancelDeliveryRequestProps = {
  input: CancelDeliveryRequestInput;
};

export async function cancelDeliveryRequest({
  input,
}: CancelDeliveryRequestProps): Promise<void> {
  return withAuth<void>(async (ctx, policies) => {
    // 1. Validate permissions
    policies.canCancelDeliveryRequest();

    // 2. Validate input
    const validatedInput = CancelDeliveryRequestSchema.parse(input);

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
      throw new Error("Can only cancel own delivery requests");
    }

    // 5. Check cutoff time
    const modifyCheck = await canModifyRequest({
      clientCompanyId: ctx.company.id,
      requestDate: existingRequest.date.toISOString().split("T")[0],
    });

    if (!modifyCheck.canModify) {
      throw new Error(
        `Cannot cancel request: cutoff time (${modifyCheck.cutoffTime}) has passed`,
      );
    }

    // 6. Check if any stops are assigned to any deliveries
    const hasAssignedDeliveries = existingRequest.stops.some(
      (stop) => stop.deliveryStopId !== null,
    );

    if (hasAssignedDeliveries) {
      throw new Error(
        "Cannot cancel request: request has been used to create deliveries. Please contact the delivery company to make changes.",
      );
    }

    // 7. Delete request (cascade will delete stops)
    await prisma.deliveryRequest.delete({
      where: { id: validatedInput.requestId },
    });

    // 9. Revalidate and redirect
    revalidatePath("/delivery-requests");
    redirect("/delivery-requests");
  });
}
