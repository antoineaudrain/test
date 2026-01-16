import { Badge, type BadgeColor } from "@/features/shared/components";
import type { StopStatus } from "@/generated/prisma";

type StopBadgeConfig = {
  color: BadgeColor;
  label: string;
};

const stopStatusConfig: Record<StopStatus, StopBadgeConfig> = {
  PLANNED: { color: "zinc", label: "En attente" },
  EN_ROUTE: { color: "blue", label: "En transit" },
  DELIVERED: { color: "emerald", label: "Livré" },
  FAILED: { color: "red", label: "Annulé" },
};

type StopStatusBadgeProps = { status: StopStatus };

export function StopStatusBadge({ status }: StopStatusBadgeProps) {
  const config = stopStatusConfig[status];

  return <Badge color={config.color}>{config.label}</Badge>;
}
