import { Badge, type BadgeColor } from "@/features/shared/components";
import type { DeliveryStatus } from "@/generated/prisma";

type StatusBadgeConfig = { color: BadgeColor; label: string };

const STATUS_MAP: Record<DeliveryStatus, StatusBadgeConfig> = {
  SCHEDULED: { color: "blue", label: "Planifiée" },
  IN_PROGRESS: { color: "indigo", label: "En cours" },
  COMPLETED: { color: "emerald", label: "Terminée" },
  CANCELLED: { color: "rose", label: "Annulée" },
};

type StatusBadgeProps = {
  deliveryStatus?: DeliveryStatus;
};

export function StatusBadge({ deliveryStatus }: StatusBadgeProps) {
  if (!deliveryStatus) {
    return null;
  }

  const config = STATUS_MAP[deliveryStatus];

  if (!config) {
    return null;
  }

  return <Badge color={config.color}>{config.label}</Badge>;
}
