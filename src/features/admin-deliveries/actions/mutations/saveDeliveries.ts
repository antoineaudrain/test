"use server";

import { revalidatePath } from "next/cache";
import {
  type SaveDeliveriesInput,
  SaveDeliveriesSchema,
} from "@/features/admin-deliveries/schemas/saveDeliveries";
import { DeliveryStatus, StopStatus } from "@/generated/prisma";
import prisma from "@/lib/database/prisma";
import { withAuth } from "@/lib/permissions";
import { dateStringToDate, Time } from "@/lib/time";

export type SaveDeliveriesResult = {
  created: number;
  updated: number;
  deleted: number;
};

export async function saveDeliveries(
  input: SaveDeliveriesInput,
): Promise<SaveDeliveriesResult> {
  return withAuth<SaveDeliveriesResult>(async (ctx, policies) => {
    // 1. Validate permissions
    policies.canSaveDeliveries();

    // 2. Validate input
    const validatedInput = SaveDeliveriesSchema.parse(input);

    // 3. Validate driver and vehicle belong to company
    const drivers = await prisma.user.findMany({
      where: {
        id: { in: validatedInput.deliveries.map((d) => d.driverId) },
        companyId: ctx.company.id,
      },
      include: { vehicle: true },
    });

    const vehicles = await prisma.vehicle.findMany({
      where: {
        id: { in: validatedInput.deliveries.map((d) => d.vehicleId) },
        companyId: ctx.company.id,
      },
    });

    for (const delivery of validatedInput.deliveries) {
      const driver = drivers.find((d) => d.id === delivery.driverId);
      if (!driver) {
        throw new Error(
          `Driver ${delivery.driverId} not found or not in company`,
        );
      }

      const vehicle = vehicles.find((v) => v.id === delivery.vehicleId);
      if (!vehicle) {
        throw new Error(
          `Vehicle ${delivery.vehicleId} not found or not in company`,
        );
      }
    }

    // 4. Check existing deliveries not IN_PROGRESS/COMPLETED
    if (validatedInput.deletedDeliveryIds?.length) {
      const deliveriesToDelete = await prisma.delivery.findMany({
        where: {
          id: { in: validatedInput.deletedDeliveryIds },
        },
      });

      for (const delivery of deliveriesToDelete) {
        if (
          delivery.deliveryStatus === DeliveryStatus.IN_PROGRESS ||
          delivery.deliveryStatus === DeliveryStatus.COMPLETED
        ) {
          throw new Error(
            `Cannot delete delivery ${delivery.number}: delivery has started or completed`,
          );
        }
      }
    }

    // Check existing deliveries to update
    const existingDeliveryIds = validatedInput.deliveries
      .map((d) => d.id)
      .filter((id): id is string => id !== undefined && id !== null);

    if (existingDeliveryIds.length > 0) {
      const deliveriesToUpdate = await prisma.delivery.findMany({
        where: {
          id: { in: existingDeliveryIds },
        },
      });

      for (const delivery of deliveriesToUpdate) {
        if (
          delivery.deliveryStatus === DeliveryStatus.IN_PROGRESS ||
          delivery.deliveryStatus === DeliveryStatus.COMPLETED
        ) {
          throw new Error(
            `Cannot update delivery ${delivery.number}: delivery has started or completed`,
          );
        }
      }
    }

    // 5. Execute operations
    let created = 0;
    let updated = 0;
    let deleted = 0;

    // A. Delete specified deliveries
    if (validatedInput.deletedDeliveryIds?.length) {
      // First, unlink delivery stops from request stops
      await prisma.deliveryRequestStop.updateMany({
        where: {
          deliveryStop: {
            deliveryId: { in: validatedInput.deletedDeliveryIds },
          },
        },
        data: {
          deliveryStopId: null,
        },
      });

      // Then delete deliveries (cascade will delete stops)
      const deleteResult = await prisma.delivery.deleteMany({
        where: {
          id: { in: validatedInput.deletedDeliveryIds },
        },
      });

      deleted = deleteResult.count;
    }

    // B. Process each delivery
    for (const deliveryInput of validatedInput.deliveries) {
      const driver = drivers.find((d) => d.id === deliveryInput.driverId);
      const vehicle = vehicles.find((v) => v.id === deliveryInput.vehicleId);

      if (!driver) {
        throw new Error(`Driver ${deliveryInput.driverId} not found`);
      }
      if (!vehicle) {
        throw new Error(`Vehicle ${deliveryInput.vehicleId} not found`);
      }

      // Get request stops
      const requestStops = await prisma.deliveryRequestStop.findMany({
        where: {
          id: { in: deliveryInput.requestStopIds },
        },
        include: {
          address: true,
          endClientCompany: true,
          request: {
            include: {
            },
          },
        },
        orderBy: {
          sequence: "asc",
        },
      });

      if (requestStops.length !== deliveryInput.requestStopIds.length) {
        throw new Error("Some request stops not found");
      }

      // No need to validate client company - deliveries can have stops from multiple clients

      if (deliveryInput.id) {
        // UPDATE existing delivery
        // Unlink old stops
        await prisma.deliveryRequestStop.updateMany({
          where: {
            deliveryStop: {
              deliveryId: deliveryInput.id,
            },
          },
          data: {
            deliveryStopId: null,
          },
        });

        // Delete old stops
        await prisma.stop.deleteMany({
          where: {
            deliveryId: deliveryInput.id,
          },
        });

        // Update delivery
        await prisma.delivery.update({
          where: { id: deliveryInput.id },
          data: {
            driverId: driver.id,
            vehicleId: vehicle.id,
            driverName: `${driver.firstName} ${driver.lastName}`,
            vehicleLicensePlate: vehicle.plate,
            notes: deliveryInput.label,
          },
        });

        // Create new stops
        for (let i = 0; i < requestStops.length; i++) {
          const requestStop = requestStops[i];

          const stop = await prisma.stop.create({
            data: {
              deliveryId: deliveryInput.id,
              sequence: i + 1,
              type: requestStop.type,
              notes: requestStop.notes,
              addressId: requestStop.addressId,
              endClientId: requestStop.endClientId,
              status: StopStatus.PLANNED,
            },
          });

          // Link back to request stop
          await prisma.deliveryRequestStop.update({
            where: { id: requestStop.id },
            data: { deliveryStopId: stop.id },
          });
        }

        updated++;
      } else {
        // CREATE new delivery
        // Generate delivery number
        const year = Time().format("YY");
        const count = await prisma.delivery.count({
          where: {
            number: { startsWith: `TDS${year}-` },
          },
        });
        const sequence = (count + 1).toString().padStart(4, "0");
        const deliveryNumber = `TDS${year}-${sequence}`;

        // Create delivery
        const delivery = await prisma.delivery.create({
          data: {
            number: deliveryNumber,
            date: dateStringToDate(validatedInput.date),
            notes: deliveryInput.label,
            deliveryCompanyId: ctx.company.id,
            driverId: driver.id,
            vehicleId: vehicle.id,
            driverName: `${driver.firstName} ${driver.lastName}`,
            vehicleLicensePlate: vehicle.plate,
            deliveryStatus: DeliveryStatus.SCHEDULED,
          },
        });

        // Create stops
        for (let i = 0; i < requestStops.length; i++) {
          const requestStop = requestStops[i];

          const stop = await prisma.stop.create({
            data: {
              deliveryId: delivery.id,
              sequence: i + 1,
              type: requestStop.type,
              notes: requestStop.notes,
              addressId: requestStop.addressId,
              endClientId: requestStop.endClientId,
              status: StopStatus.PLANNED,
            },
          });

          // Link back to request stop
          await prisma.deliveryRequestStop.update({
            where: { id: requestStop.id },
            data: { deliveryStopId: stop.id },
          });
        }

        created++;
      }
    }

    // 6. Revalidate paths
    revalidatePath("/deliveries");
    revalidatePath("/deliveries/new");

    return { created, updated, deleted };
  });
}
