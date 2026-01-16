import { Badge, type BadgeColor } from "@/features/shared/components";
import type { UserRole } from "@/generated/prisma";

type EmployeeRoleBadgeConfig = {
  color: BadgeColor;
  label: string;
};

const employeeRoleConfig: Record<UserRole, EmployeeRoleBadgeConfig> = {
  ADMIN: { color: "blue", label: "Administrateur" },
  MANAGER: { color: "indigo", label: "Manager" },
  MEMBER: { color: "emerald", label: "Collaborateur" },
};

type EmployeeRoleBadgeProps = { role: UserRole };

export function EmployeeRoleBadge({ role }: EmployeeRoleBadgeProps) {
  const config = employeeRoleConfig[role];

  return <Badge color={config.color}>{config.label}</Badge>;
}
