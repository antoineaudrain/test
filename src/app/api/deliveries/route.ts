import { NextResponse } from "next/server";
import { CreateDeliveryFormSchema } from "@/features/deliveries/schema/createDelivery";
import { sendNotificationEmail } from "@/features/emails/actions/sendNotificationEmail";
import { DeliveryCreatedNotification } from "@/features/emails/templates/DeliveryCreatedNotification";
import { DeliveryStatus } from "@/generated/prisma";
import prisma from "@/lib/database/prisma";
import { withAuth } from "@/lib/permissions";
import { dateStringToDate, Time } from "@/lib/time";

export const POST = async (req: Request) => {
  try {
    const body = await req.json();
    const input = CreateDeliveryFormSchema.parse(body);

    const result = await withAuth(async (ctx) => {
      if (!ctx.company.parentCompany?.id) {
        throw new Error("Delivery company not found");
      }

      const { stops, ...deliveryData } = input;

      // Get end client companies to validate and get addresses
      const endClientIds = stops
        .filter((stop) => stop.selected && stop.type)
        .map((stop) => stop.companyId);

      const endClients = await prisma.company.findMany({
        where: {
          id: { in: endClientIds },
          parentId: ctx.company.id, // Ensure they belong to this client company
          type: "END_CLIENT",
        },
        include: {
          address: true,
        },
      });

      const stopsData = stops
        .filter((stop) => stop.selected && stop.type)
        .map((stop) => {
          const endClient = endClients.find((ec) => ec.id === stop.companyId);
          if (!endClient) {
            throw new Error(`End client not found: ${stop.companyId}`);
          }
          return {
            sequence: stop.sequence,
            type: stop.type as "PICKUP" | "DROPOFF" | "BOTH",
            notes: stop.notes,
            endClientId: stop.companyId,
            addressId: endClient.addressId,
          };
        });

      if (!stopsData.length) {
        throw new Error("At least one stop must be selected");
      }

      // Generate delivery number
      const year = Time().format("YY");
      const count = await prisma.delivery.count({
        where: {
          number: { startsWith: `TDS${year}-` },
        },
      });
      const sequence = (count + 1).toString().padStart(4, "0");
      const deliveryNumber = `TDS${year}-${sequence}`;

      // NOTE: This API route is deprecated. Use DeliveryRequest instead.
      // Creating delivery directly with SCHEDULED status for backward compatibility.
      const delivery = await prisma.delivery.create({
        data: {
          number: deliveryNumber,
          deliveryStatus: DeliveryStatus.SCHEDULED,
          date: dateStringToDate(deliveryData.date),
          notes: deliveryData.notes,
          deliveryCompany: { connect: { id: ctx.company.parentCompany.id } },
          clientCompany: { connect: { id: ctx.company.id } },
          stops: { create: stopsData },
        },
      });

      // Send email notification
      sendNotificationEmail({
        subject: `📦 Nouvelle Demande de Livraison: ${ctx.company.name}`,
        template: DeliveryCreatedNotification({
          clientName: ctx.company.name,
          requestedDate: dateStringToDate(input.date),
        }),
        meta: {
          source: "delivery-system",
          type: "delivery-created",
          priority: "high",
          deliveryId: delivery.id,
          clientId: ctx.company.id,
        },
      }).catch((err) => console.error("Email send failed:", err));

      return { id: delivery.id };
    });

    return NextResponse.json(result, { status: 201 });
  } catch (err) {
    console.error("Create delivery error:", err);
    return NextResponse.json(
      { error: err instanceof Error ? err.message : "Failed to new delivery" },
      { status: 500 },
    );
  }
};
