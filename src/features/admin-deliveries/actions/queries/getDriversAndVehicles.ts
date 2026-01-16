"use server";

import prisma from "@/lib/database/prisma";
import { withAuth } from "@/lib/permissions";

type Driver = {
  id: string;
  firstName: string;
  lastName: string;
  vehicleId: string | null;
};

type Vehicle = {
  id: string;
  plate: string;
  model: string | null;
};

export async function getDriversAndVehicles(): Promise<{
  drivers: Driver[];
  vehicles: Vehicle[];
}> {
  return withAuth(async (ctx, policies) => {
    // Only for delivery companies
    if (!policies.isDeliveryCompany()) {
      return { drivers: [], vehicles: [] };
    }

    const [users, vehicles] = await Promise.all([
      prisma.user.findMany({
        where: {
          companyId: ctx.company.id,
          role: { in: ["ADMIN", "MANAGER", "MEMBER"] },
        },
        select: {
          id: true,
          firstName: true,
          lastName: true,
          vehicleId: true,
        },
        orderBy: [{ firstName: "asc" }, { lastName: "asc" }],
      }),
      prisma.vehicle.findMany({
        where: {
          companyId: ctx.company.id,
        },
        select: {
          id: true,
          plate: true,
          model: true,
        },
        orderBy: { plate: "asc" },
      }),
    ]);

    return {
      drivers: users,
      vehicles,
    };
  });
}
