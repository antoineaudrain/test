import type { Metadata } from "next";
import { listEmployee } from "@/features/employees/actions/queries/listEmployee";
import {
  EmployeeTable,
  type EmployeeTableRow,
} from "@/features/employees/components/EmployeeTable";
import { Heading } from "@/features/shared/components";
import { requirePermission } from "@/lib/permissions";

export const metadata: Metadata = {
  title: "Collaborateurs",
  description: "Tous les membres de votre société",
};

export default async function EmployeeListPage() {
  await requirePermission((policies) => policies.canViewEmployeeListPage());

  const employees = await listEmployee();
  const data = employees.map<EmployeeTableRow>((employee) => ({
    id: employee.id,
    displayName: `${employee.lastName} ${employee.firstName}`,
    email: `${employee.email}`,
    role: employee.role,
    createdAt: employee.createdAt,
  }));

  return (
    <div className="space-y-8">
      <div className="flex flex-wrap items-end justify-between gap-4">
        <div className="flex flex-col max-sm:w-full sm:flex-1 gap-y-2">
          <Heading>Collaborateurs</Heading>
        </div>
      </div>

      <EmployeeTable data={data} />
    </div>
  );
}
