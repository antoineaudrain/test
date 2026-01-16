"use client";

import { useTransition } from "react";
import { resumeDelivery } from "@/features/deliveries/actions/mutations/resumeDelivery";
import { Button } from "@/features/shared/components";

type ResumeDeliveryButtonProps = {
  deliveryId: string;
};

export function ResumeDeliveryButton({
  deliveryId,
}: ResumeDeliveryButtonProps) {
  const [isPending, startTransition] = useTransition();

  const handleResume = () => {
    startTransition(async () => {
      await resumeDelivery({ deliveryId });
    });
  };

  return (
    <Button onClick={handleResume} loading={isPending}>
      Reprendre la livraison
    </Button>
  );
}
