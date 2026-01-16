"use server";

import type { EmployeeWithRelations } from "@/features/employees/types";
import prisma from "@/lib/database/prisma";
import { withAuth } from "@/lib/permissions";

type ListDriverReturn = EmployeeWithRelations<{ vehicle: true }>[];

export async function listDriver(): Promise<ListDriverReturn> {
  return withAuth<ListDriverReturn>(async (ctx, policies) => {
    const employees = await prisma.user.findMany({
      where: {
        companyId: ctx.company.id,
        vehicleId: {
          not: null,
        },
      },
      include: {
        vehicle: true,
      },
    });

    policies.canViewEmployees(employees);

    return employees;
  });
}
