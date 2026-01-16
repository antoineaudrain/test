"use server";

import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import prisma from "@/lib/database/prisma";
import { withAuth } from "@/lib/permissions";

type AssignVehicleProps = {
  employeeId: string;
  vehicleId: string;
};

export async function assignVehicle({
  employeeId,
  vehicleId,
}: AssignVehicleProps): Promise<void> {
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
      data: { vehicleId },
    });

    revalidatePath("/vehicles");
    revalidatePath("/employees");
    revalidatePath(`/employees/${employeeId}`);
    redirect(`/employees/${employeeId}?tab=driver-details`);
  });
}
