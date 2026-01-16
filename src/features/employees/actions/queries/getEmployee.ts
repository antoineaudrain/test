"use server";

import type { EmployeeWithRelations } from "@/features/employees/types";
import prisma from "@/lib/database/prisma";
import { withAuth } from "@/lib/permissions";

type GetEmployeeReturn = EmployeeWithRelations<{ vehicle: true }> | null;

type GetEmployeeProps = {
  employeeId: string;
};

export async function getEmployee({
  employeeId,
}: GetEmployeeProps): Promise<GetEmployeeReturn> {
  return withAuth<GetEmployeeReturn>(async (ctx, policies) => {
    const employee = await prisma.user.findFirst({
      where: {
        id: employeeId,
        companyId: ctx.company.id,
      },
      include: {
        vehicle: true,
      },
    });

    if (!employee) throw new Error("Employee not found");
    policies.canViewEmployee(employee);

    return employee;
  });
}
