"use client";

import UserEmpty from "@/assets/illustrations/user-empty.svg";
import { EmptyState } from "@/features/shared/components";

export default function ClientNotFound() {
  return (
    <EmptyState
      icon={UserEmpty}
      title="Collaborateur introuvable"
      description="Ce collaborateur n'existe pas ou vous n'avez pas les permissions pour y accéder."
    />
  );
}
