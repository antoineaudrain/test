"use server";

import type { VehicleWithRelations } from "@/features/vehicles/types";
import prisma from "@/lib/database/prisma";
import { withAuth } from "@/lib/permissions";

type ListVehicleReturn = VehicleWithRelations<{ drivers: true }>[];

export async function listVehicles(): Promise<ListVehicleReturn> {
  return withAuth<ListVehicleReturn>(async (ctx, policies) => {
    const vehicles = await prisma.vehicle.findMany({
      where: {
        companyId: ctx.company.id,
      },
      include: {
        drivers: true,
      },
    });

    policies.canViewVehicles(vehicles);

    return vehicles;
  });
}
