"use server";

import type { Employee } from "@/features/employees/types";
import prisma from "@/lib/database/prisma";
import { withAuth } from "@/lib/permissions";

type ListEmployeeReturn = Employee[];

export async function listEmployee(): Promise<ListEmployeeReturn> {
  return withAuth<ListEmployeeReturn>(async (ctx, policies) => {
    const employees = await prisma.user.findMany({
      where: {
        companyId: ctx.company.id,
      },
    });

    policies.canViewEmployees(employees);

    return employees;
  });
}
