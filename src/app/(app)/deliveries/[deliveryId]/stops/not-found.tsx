"use client";

import NavigationEmpty from "@/assets/illustrations/navigation-empty.svg";
import { EmptyState } from "@/features/shared/components";

export default function StepNotFound() {
  return (
    <EmptyState
      icon={NavigationEmpty}
      title="Arrêt introuvable"
      description="Cette arrêt de livraison n'existe pas ou vous n'avez pas les permissions pour y accéder."
    />
  );
}
