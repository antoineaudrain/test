"use server";

import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import { canModifyRequest } from "@/features/delivery-requests/actions/queries/canModifyRequest";
import {
  type CreateDeliveryRequestInput,
  CreateDeliveryRequestSchema,
} from "@/features/delivery-requests/schemas/deliveryRequest";
import { sendNotificationEmail } from "@/features/emails/actions/sendNotificationEmail";
import { DeliveryCreatedNotification } from "@/features/emails/templates/DeliveryCreatedNotification";
import prisma from "@/lib/database/prisma";
import { withAuth } from "@/lib/permissions";
import { dateStringToDate } from "@/lib/time";

type CreateDeliveryRequestProps = {
  input: CreateDeliveryRequestInput;
};

export async function createDeliveryRequest({
  input,
}: CreateDeliveryRequestProps): Promise<void> {
  return withAuth<void>(async (ctx, policies) => {
    // 1. Validate permissions
    policies.canCreateDeliveryRequest();

    // 2. Validate input
    const validatedInput = CreateDeliveryRequestSchema.parse(input);

    // 3. Get parent company (delivery company)
    if (!ctx.company.parentCompany?.id) {
      throw new Error("Delivery company not found");
    }

    // 4. Check cutoff time
    const modifyCheck = await canModifyRequest({
      clientCompanyId: ctx.company.id,
      requestDate: validatedInput.date,
    });

    if (!modifyCheck.canModify) {
      throw new Error(
        `Cannot create request: cutoff time (${modifyCheck.cutoffTime}) has passed`,
      );
    }

    // 5. Check for existing request (unique constraint)
    const existingRequest = await prisma.deliveryRequest.findUnique({
      where: {
        clientCompanyId_date: {
          clientCompanyId: ctx.company.id,
          date: dateStringToDate(validatedInput.date),
        },
      },
    });

    if (existingRequest) {
      throw new Error("A delivery request already exists for this date");
    }

    // 6. Create request with stops
    const request = await prisma.deliveryRequest.create({
      data: {
        date: dateStringToDate(validatedInput.date),
        notes: validatedInput.notes,
        clientCompanyId: ctx.company.id,
        deliveryCompanyId: ctx.company.parentCompany.id,
        stops: {
          create: validatedInput.stops.map((stop) => ({
            sequence: stop.sequence,
            type: stop.type,
            notes: stop.notes,
            addressId: stop.addressId,
            endClientId: stop.endClientId,
          })),
        },
      },
      include: {
        stops: {
          include: {
            endClientCompany: true,
          },
        },
      },
    });

    // 7. Send notification email
    try {
      await sendNotificationEmail({
        subject: `📦 Nouvelle Demande de Livraison: ${ctx.company.name}`,
        template: DeliveryCreatedNotification({
          clientName: ctx.company.name,
          requestedDate: dateStringToDate(validatedInput.date),
        }),
        meta: {
          source: "delivery-request-system",
          type: "delivery-request-created",
          priority: "high",
          deliveryId: request.id,
          clientId: ctx.company.id,
        },
      });
    } catch (error) {
      console.error("Failed to send notification email:", error);
      // Don't fail the request creation if email fails
    }

    // 8. Revalidate and redirect
    revalidatePath("/delivery-requests");
    redirect("/delivery-requests");
  });
}
