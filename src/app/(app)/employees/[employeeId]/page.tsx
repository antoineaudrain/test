import { ChevronLeftIcon } from "lucide-react";
import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { getEmployee } from "@/features/employees/actions/queries/getEmployee";
import { EditEmployeeForm } from "@/features/employees/components/EditEmployeeForm";
import { EmployeeRoleBadge } from "@/features/employees/components/EmployeeRoleBadge";
import { ManageEmployeeVehicleForm } from "@/features/employees/components/ManageEmployeeVehicleForm";
import { Heading, Link } from "@/features/shared/components";
import { safe } from "@/features/shared/helper/safe";
import { listVehicles } from "@/features/vehicles/actions/queries/listVehicles";
import { checkPermission, requirePermission } from "@/lib/permissions";

type EmployeeDetailsPageProps = {
  params: Promise<{ employeeId: string }>;
};

export async function generateMetadata({
  params,
}: EmployeeDetailsPageProps): Promise<Metadata> {
  const { employeeId } = await params;
  const employee = await getEmployee({ employeeId });
  if (!employee) {
    notFound();
  }

  return {
    title: `${employee.firstName} ${employee.lastName}`,
  };
}

export default async function EmployeeDetailsPage({
  params,
}: EmployeeDetailsPageProps) {
  await requirePermission((policies) => policies.canViewEmployeeDetailsPage());

  const { employeeId } = await params;
  const employee = await getEmployee({ employeeId });
  if (!employee) {
    notFound();
  }

  const vehicles = await safe(listVehicles(), []);
  const { hasPermission: canViewVehicles } = await checkPermission((policies) =>
    policies.canViewVehicles(vehicles),
  );

  return (
    <>
      <div className="max-lg:hidden">
        <Link
          href="/employees"
          className="inline-flex items-center gap-2 text-sm/6 text-zinc-500 dark:text-zinc-400"
        >
          <ChevronLeftIcon className="size-4 text-zinc-400 dark:text-zinc-500" />
          Retour
        </Link>
      </div>

      <div className="flex flex-col gap-4 lg:gap-8">
        <div className="flex items-center gap-4">
          <Heading>
            {employee.lastName} {employee.firstName}
          </Heading>
          <EmployeeRoleBadge role={employee.role} />
        </div>

        {canViewVehicles && (
          <ManageEmployeeVehicleForm
            employeeId={employee.id}
            vehicleId={employee.vehicleId ?? undefined}
            vehicles={vehicles}
          />
        )}

        <EditEmployeeForm employeeId={employee.id} defaultValues={employee} />
      </div>
    </>
  );
}
