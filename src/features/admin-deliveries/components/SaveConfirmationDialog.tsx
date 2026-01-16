"use client";

import { CheckCircleIcon, TruckIcon } from "lucide-react";
import type { DeliveryRequestStopWithDetails } from "@/features/delivery-requests/types";
import { Button, Dialog } from "@/features/shared/components";

type DeliveryState = {
  id?: string;
  label: string;
  driverId: string;
  vehicleId: string;
  endClientIds: string[];
};

type EndClient = {
  id: string;
  name: string;
  requestStops: DeliveryRequestStopWithDetails[];
};

type SaveConfirmationDialogProps = {
  deliveries: DeliveryState[];
  endClients: EndClient[];
  onConfirm: () => void;
  onCancel: () => void;
};

export function SaveConfirmationDialog({
  deliveries,
  endClients,
  onConfirm,
  onCancel,
}: SaveConfirmationDialogProps) {
  const totalStops = deliveries.reduce((sum, d) => {
    const stops = d.endClientIds.reduce((stopSum, ecId) => {
      const ec = endClients.find((e) => e.id === ecId);
      return stopSum + (ec?.requestStops.length || 0);
    }, 0);
    return sum + stops;
  }, 0);

  return (
    <Dialog open onClose={onCancel}>
      <div
        className="fixed inset-0 bg-black/30 z-50"
        onClick={onCancel}
        onKeyDown={(e) => {
          if (e.key === "Escape") onCancel();
        }}
        role="button"
        tabIndex={0}
        aria-label="Close dialog"
      />
      <div className="fixed inset-0 flex items-center justify-center z-50 p-4">
        <div className="bg-white dark:bg-zinc-900 rounded-lg shadow-xl max-w-2xl w-full p-6">
          {/* Header */}
          <div className="flex items-center gap-3 mb-6">
            <CheckCircleIcon className="h-6 w-6 text-green-600" />
            <h2 className="text-xl font-semibold text-zinc-900 dark:text-white">
              Confirmer la sauvegarde
            </h2>
          </div>

          {/* Summary */}
          <div className="space-y-4 mb-6">
            <div className="flex items-center justify-between p-4 bg-zinc-100 dark:bg-zinc-800 rounded-lg">
              <div>
                <p className="text-sm text-zinc-600 dark:text-zinc-400">
                  Nombre de livraisons
                </p>
                <p className="text-2xl font-bold text-zinc-900 dark:text-white">
                  {deliveries.length}
                </p>
              </div>
              <div>
                <p className="text-sm text-zinc-600 dark:text-zinc-400">
                  Nombre d'arrêts
                </p>
                <p className="text-2xl font-bold text-zinc-900 dark:text-white">
                  {totalStops}
                </p>
              </div>
            </div>

            {/* Delivery List */}
            <div className="space-y-2 max-h-96 overflow-y-auto">
              {deliveries.map((delivery) => {
                const deliveryEndClients = endClients.filter((ec) =>
                  delivery.endClientIds.includes(ec.id),
                );
                const deliveryStops = deliveryEndClients.reduce(
                  (sum, ec) => sum + ec.requestStops.length,
                  0,
                );

                return (
                  <div
                    key={
                      delivery.id || `${delivery.label}-${delivery.driverId}`
                    }
                    className="flex items-center gap-3 p-3 border border-zinc-200 dark:border-zinc-700 rounded-lg"
                  >
                    <TruckIcon className="h-5 w-5 text-zinc-600 dark:text-zinc-400" />
                    <div className="flex-1 min-w-0">
                      <p className="font-medium text-zinc-900 dark:text-white truncate">
                        {delivery.label}
                      </p>
                      <p className="text-sm text-zinc-600 dark:text-zinc-400">
                        {deliveryStops} arrêt{deliveryStops > 1 ? "s" : ""} •{" "}
                        {deliveryEndClients.length} destinataire
                        {deliveryEndClients.length > 1 ? "s" : ""}
                      </p>
                    </div>
                    {delivery.id && (
                      <span className="text-xs text-zinc-500 dark:text-zinc-400">
                        (mise à jour)
                      </span>
                    )}
                    {!delivery.id && (
                      <span className="text-xs text-green-600 dark:text-green-400">
                        (nouveau)
                      </span>
                    )}
                  </div>
                );
              })}
            </div>
          </div>

          {/* Actions */}
          <div className="flex gap-3 justify-end">
            <Button outline onClick={onCancel}>
              Annuler
            </Button>
            <Button onClick={onConfirm}>Confirmer et Sauvegarder</Button>
          </div>
        </div>
      </div>
    </Dialog>
  );
}
