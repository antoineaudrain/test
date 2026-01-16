"use server";

import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import type { UpdateEmployeeFormInput } from "@/features/employees/schemas/updateEmployee";
import prisma from "@/lib/database/prisma";
import { withAuth } from "@/lib/permissions";

type UpdateEmployeeProps = {
  employeeId: string;
  input: UpdateEmployeeFormInput;
};

export async function updateEmployee({
  employeeId,
  input,
}: UpdateEmployeeProps): Promise<void> {
  return withAuth<void>(async (ctx, policies) => {
    const employee = await prisma.user.findUnique({
      where: {
        id: employeeId,
        companyId: ctx.company.id,
      },
    });

    if (!employee) throw new Error("Employee not found");
    policies.canUpdateEmployee(employee);

    await prisma.user.update({
      where: {
        id: employeeId,
        companyId: ctx.company.id,
      },
      data: input,
    });

    revalidatePath("/employees");
    revalidatePath(`/employees/${employeeId}`);
    redirect(`/employees/${employeeId}?tab=employee-details`);
  });
}
