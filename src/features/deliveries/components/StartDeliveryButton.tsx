"use client";

import { useState, useTransition } from "react";
import { startDelivery } from "@/features/deliveries/actions/mutations/startDelivery";
import {
  Alert,
  AlertActions,
  AlertDescription,
  AlertTitle,
  Button,
  TouchTarget,
} from "@/features/shared/components";

type StartDeliveryButtonProps = {
  deliveryId: string;
};

export function StartDeliveryButton({ deliveryId }: StartDeliveryButtonProps) {
  const [isOpen, setIsOpen] = useState(false);
  const [isPending, startTransition] = useTransition();

  const openAlert = () => setIsOpen(true);
  const closeAlert = () => setIsOpen(false);
  const handleDelete = () => {
    startTransition(async () => {
      await startDelivery({ deliveryId });
      closeAlert();
    });
  };

  return (
    <>
      <Button onClick={openAlert} loading={isPending}>
        <TouchTarget>Commencer</TouchTarget>
      </Button>

      <Alert open={isOpen} onClose={closeAlert}>
        <AlertTitle>Commencer cette livraison ?</AlertTitle>
        <AlertDescription>
          Cette action marquera la livraison comme <strong>en cours</strong>.
          Vous pourrez suivre son avancement, et les arrêts prévus seront mis à
          jour en conséquence.
        </AlertDescription>
        <AlertActions>
          <Button plain onClick={closeAlert}>
            Annuler
          </Button>
          <Button onClick={handleDelete}>Confirmer</Button>
        </AlertActions>
      </Alert>
    </>
  );
}
