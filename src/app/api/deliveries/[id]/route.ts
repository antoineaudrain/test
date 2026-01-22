import { NextResponse } from "next/server";
import { UpdateDeliveryFormSchema } from "@/features/deliveries/schema/updateDelivery";
import prisma from "@/lib/database/prisma";
import { withAuth } from "@/lib/permissions";

export const PATCH = async (
  req: Request,
  { params }: { params: Promise<{ id: string }> },
) => {
  try {
    const deliveryId = (await params).id;
    const body = await req.json();
    const input = UpdateDeliveryFormSchema.parse(body);

    await withAuth(async () => {
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

      const { stops, ...deliveryData } = input;

      const stopsData = stops
        .filter((stop) => stop.selected && stop.type)
        .map((stop) => {
          const existingStop = delivery.stops.find(
            (s) => s.endClientCompany.id === stop.companyId,
          );
          if (!existingStop?.endClientCompany?.addressId) {
            throw new Error(
              `Stop not found or missing address for companyId ${stop.companyId}`,
            );
          }
          return {
            sequence: stop.sequence,
            type: stop.type as "PICKUP" | "DROPOFF" | "BOTH",
            notes: stop.notes,
            endClientId: stop.companyId,
            addressId: existingStop.endClientCompany.addressId,
          };
        });

      if (!stopsData.length) {
        throw new Error("At least one stop must be selected");
      }

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
    });

    return NextResponse.json({ success: true }, { status: 200 });
  } catch (err) {
    console.error("Update delivery error:", err);
    return NextResponse.json(
      {
        error: err instanceof Error ? err.message : "Failed to update delivery",
      },
      { status: 500 },
    );
  }
};
