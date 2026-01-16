"use client";

import UserEmpty from "@/assets/illustrations/user-empty.svg";
import { EmptyState } from "@/features/shared/components";

export default function ClientNotFound() {
  return (
    <EmptyState
      icon={UserEmpty}
      title="Client introuvable"
      description="Ce client n'existe pas ou vous n'avez pas les permissions pour y accéder."
    />
  );
}
