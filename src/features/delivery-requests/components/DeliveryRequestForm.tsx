"use client";

import { AlertCircleIcon, PlusIcon, SaveIcon, Trash2Icon } from "lucide-react";
import { useRouter } from "next/navigation";
import { useEffect, useState, useTransition } from "react";
import { cancelDeliveryRequest } from "@/features/delivery-requests/actions/mutations/cancelDeliveryRequest";
import { createDeliveryRequest } from "@/features/delivery-requests/actions/mutations/createDeliveryRequest";
import { updateDeliveryRequest } from "@/features/delivery-requests/actions/mutations/updateDeliveryRequest";
import type { DeliveryRequestWithStops } from "@/features/delivery-requests/types";
import { Button, Input, Textarea } from "@/features/shared/components";
import { Time } from "@/lib/time";

type DeliveryRequestFormProps = {
  mode: "create" | "edit";
  request?: DeliveryRequestWithStops;
};

type StopFormData = {
  id?: string;
  sequence: number;
  type: "PICKUP" | "DROPOFF" | "BOTH";
  endClientId: string;
  addressId: string;
  notes?: string;
};

export function DeliveryRequestForm({
  mode,
  request,
}: DeliveryRequestFormProps) {
  const router = useRouter();
  const [isPending, startTransition] = useTransition();
  const [date, setDate] = useState(
    mode === "edit" && request
      ? Time(request.date).format("YYYY-MM-DD")
      : Time().format("YYYY-MM-DD"),
  );
  const [notes, setNotes] = useState(request?.notes || "");
  const [stops, setStops] = useState<StopFormData[]>(
    request?.stops.map((s) => ({
      id: s.id,
      sequence: s.sequence,
      type: s.type,
      endClientId: s.endClientId,
      addressId: s.addressId,
      notes: s.notes || "",
    })) || [],
  );

  const [canModify, _setCanModify] = useState(true);
  const [timeRemaining, setTimeRemaining] = useState<number | null>(null);
  const [cutoffTime, _setCutoffTime] = useState<string | null>(null);

  // Check cutoff time (only in edit mode)
  useEffect(() => {
    if (mode === "edit" && request) {
      // TODO: Get client company ID and check cutoff
      // This would require passing the company context
    }
  }, [mode, request]);

  // Update timer
  useEffect(() => {
    if (timeRemaining !== null && timeRemaining > 0) {
      const interval = setInterval(() => {
        setTimeRemaining((prev) => (prev !== null && prev > 0 ? prev - 1 : 0));
      }, 1000);
      return () => clearInterval(interval);
    }
  }, [timeRemaining]);

  const addStop = () => {
    setStops((prev) => [
      ...prev,
      {
        sequence: prev.length + 1,
        type: "DROPOFF",
        endClientId: "",
        addressId: "",
        notes: "",
      },
    ]);
  };

  const removeStop = (index: number) => {
    setStops((prev) => prev.filter((_, i) => i !== index));
  };

  const updateStop = (index: number, updates: Partial<StopFormData>) => {
    setStops((prev) =>
      prev.map((stop, i) => (i === index ? { ...stop, ...updates } : stop)),
    );
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    startTransition(async () => {
      try {
        if (mode === "create") {
          await createDeliveryRequest({
            input: {
              date,
              notes: notes || undefined,
              stops: stops.map((s, i) => ({
                sequence: i + 1,
                type: s.type,
                endClientId: s.endClientId,
                addressId: s.addressId,
                notes: s.notes || undefined,
              })),
            },
          });
        } else if (request) {
          await updateDeliveryRequest({
            input: {
              requestId: request.id,
              notes: notes || undefined,
              stops: stops.map((s, i) => ({
                id: s.id,
                sequence: i + 1,
                type: s.type,
                endClientId: s.endClientId,
                addressId: s.addressId,
                notes: s.notes || undefined,
              })),
            },
          });
        }
      } catch (error) {
        alert(
          error instanceof Error ? error.message : "Une erreur est survenue",
        );
      }
    });
  };

  const handleCancel = async () => {
    if (
      !request ||
      !confirm("Êtes-vous sûr de vouloir annuler cette demande ?")
    ) {
      return;
    }

    startTransition(async () => {
      try {
        await cancelDeliveryRequest({ input: { requestId: request.id } });
      } catch (error) {
        alert(
          error instanceof Error ? error.message : "Une erreur est survenue",
        );
      }
    });
  };

  const _formatTimeRemaining = (seconds: number) => {
    const hours = Math.floor(seconds / 3600);
    const minutes = Math.floor((seconds % 3600) / 60);
    return `${hours}h ${minutes}m`;
  };

  const hasStartedDeliveries =
    mode === "edit" &&
    request?.stops.some(
      (s) => s.deliveryStop?.delivery?.deliveryStatus === "IN_PROGRESS",
    );

  return (
    <form onSubmit={handleSubmit} className="space-y-6">
      {/* Cutoff Warning */}
      {!canModify && cutoffTime && (
        <div className="bg-red-50 dark:bg-red-950/20 border border-red-200 dark:border-red-800 rounded-lg p-4">
          <div className="flex items-start gap-3">
            <AlertCircleIcon className="h-5 w-5 text-red-600 dark:text-red-400 flex-shrink-0 mt-0.5" />
            <div>
              <p className="font-medium text-red-900 dark:text-red-100">
                Heure limite dépassée
              </p>
              <p className="text-sm text-red-700 dark:text-red-300 mt-1">
                L'heure limite de modification ({cutoffTime}) est dépassée. Vous
                ne pouvez plus modifier cette demande.
              </p>
            </div>
          </div>
        </div>
      )}

      {/* Started Deliveries Warning */}
      {hasStartedDeliveries && (
        <div className="bg-amber-50 dark:bg-amber-950/20 border border-amber-200 dark:border-amber-800 rounded-lg p-4">
          <div className="flex items-start gap-3">
            <AlertCircleIcon className="h-5 w-5 text-amber-600 dark:text-amber-400 flex-shrink-0 mt-0.5" />
            <div>
              <p className="font-medium text-amber-900 dark:text-amber-100">
                Livraison en cours
              </p>
              <p className="text-sm text-amber-700 dark:text-amber-300 mt-1">
                Certains arrêts sont assignés à des livraisons en cours. Vous ne
                pouvez pas les supprimer.
              </p>
            </div>
          </div>
        </div>
      )}

      {/* Date */}
      <div>
        <label className="block text-sm font-medium mb-2 text-zinc-900 dark:text-white">
          Date de livraison *
        </label>
        <Input
          type="date"
          value={date}
          onChange={(e) => setDate(e.target.value)}
          required
          disabled={mode === "edit" || !canModify}
        />
      </div>

      {/* Notes */}
      <div>
        <label className="block text-sm font-medium mb-2 text-zinc-900 dark:text-white">
          Notes
        </label>
        <Textarea
          value={notes}
          onChange={(e) => setNotes(e.target.value)}
          placeholder="Notes supplémentaires..."
          rows={3}
          disabled={!canModify}
        />
      </div>

      {/* Stops */}
      <div>
        <div className="flex items-center justify-between mb-4">
          <label className="text-sm font-medium text-zinc-900 dark:text-white">
            Arrêts * (minimum 1)
          </label>
          <Button type="button" outline onClick={addStop} disabled={!canModify}>
            <PlusIcon className="h-4 w-4 mr-2" />
            Ajouter un arrêt
          </Button>
        </div>

        {stops.length === 0 ? (
          <div className="text-center py-8 border-2 border-dashed border-zinc-300 dark:border-zinc-700 rounded-lg">
            <p className="text-zinc-600 dark:text-zinc-400">
              Aucun arrêt. Cliquez sur "Ajouter un arrêt" pour commencer.
            </p>
          </div>
        ) : (
          <div className="space-y-4">
            {stops.map((stop, index) => (
              <div
                key={index}
                className="border border-zinc-300 dark:border-zinc-700 rounded-lg p-4"
              >
                <div className="flex items-start gap-4">
                  <div className="flex-1 grid grid-cols-2 gap-4">
                    <div>
                      <label className="block text-sm font-medium mb-1">
                        Type
                      </label>
                      <select
                        value={stop.type}
                        onChange={(e) =>
                          updateStop(index, { type: e.target.value as any })
                        }
                        className="w-full border rounded-lg px-3 py-2 dark:bg-zinc-800 dark:border-zinc-700"
                        disabled={!canModify}
                      >
                        <option value="PICKUP">Ramassage</option>
                        <option value="DROPOFF">Livraison</option>
                        <option value="BOTH">Les deux</option>
                      </select>
                    </div>

                    <div>
                      <label className="block text-sm font-medium mb-1">
                        Client final
                      </label>
                      <Input
                        value={stop.endClientId}
                        onChange={(e) =>
                          updateStop(index, { endClientId: e.target.value })
                        }
                        placeholder="ID du client"
                        disabled={!canModify}
                      />
                    </div>

                    <div className="col-span-2">
                      <label className="block text-sm font-medium mb-1">
                        Notes
                      </label>
                      <Input
                        value={stop.notes || ""}
                        onChange={(e) =>
                          updateStop(index, { notes: e.target.value })
                        }
                        placeholder="Notes pour cet arrêt..."
                        disabled={!canModify}
                      />
                    </div>
                  </div>

                  <Button
                    type="button"
                    outline
                    onClick={() => removeStop(index)}
                    className="text-red-600 hover:text-red-700"
                    disabled={!canModify}
                  >
                    <Trash2Icon className="h-4 w-4" />
                  </Button>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>

      {/* Actions */}
      <div className="flex gap-3 justify-end border-t border-zinc-200 dark:border-zinc-700 pt-6">
        {mode === "edit" && (
          <Button
            type="button"
            onClick={handleCancel}
            className="bg-red-600 hover:bg-red-700 text-white"
            disabled={isPending || !canModify}
          >
            Annuler la demande
          </Button>
        )}
        <Button
          type="button"
          outline
          onClick={() => router.back()}
          disabled={isPending}
        >
          Retour
        </Button>
        <Button
          type="submit"
          disabled={isPending || !canModify || stops.length === 0}
        >
          <SaveIcon className="h-4 w-4 mr-2" />
          {mode === "create" ? "Créer la demande" : "Sauvegarder"}
        </Button>
      </div>
    </form>
  );
}
