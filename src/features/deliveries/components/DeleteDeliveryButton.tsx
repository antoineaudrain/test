"use client";

import { useState, useTransition } from "react";
import { deleteDelivery } from "@/features/deliveries/actions/mutations/deleteDelivery";
import {
  Alert,
  AlertActions,
  AlertDescription,
  AlertTitle,
  Button,
  TouchTarget,
} from "@/features/shared/components";

type DeleteDeliveryButtonProps = {
  deliveryId: string;
};

export function DeleteDeliveryButton({
  deliveryId,
}: DeleteDeliveryButtonProps) {
  const [isOpen, setIsOpen] = useState(false);
  const [isPending, startTransition] = useTransition();

  const openAlert = () => setIsOpen(true);
  const closeAlert = () => setIsOpen(false);
  const handleDelete = () => {
    startTransition(async () => {
      deleteDelivery({ deliveryId });
      closeAlert();
    });
  };

  return (
    <>
      <Button color="red" onClick={openAlert} loading={isPending}>
        <TouchTarget>Supprimer</TouchTarget>
      </Button>

      <Alert open={isOpen} onClose={closeAlert}>
        <AlertTitle>
          Êtes-vous sûr de vouloir supprimer cette livraison&nbsp;?
        </AlertTitle>
        <AlertDescription>
          Toutes les informations associées à cette livraison seront perdues.
        </AlertDescription>
        <AlertActions>
          <Button plain onClick={closeAlert}>
            Annuler
          </Button>
          <Button onClick={handleDelete}>Supprimer</Button>
        </AlertActions>
      </Alert>
    </>
  );
}
