"use client";

import {
  AlertCircleIcon,
  BuildingIcon,
  CheckCircle2Icon,
  PackageIcon,
  PlusIcon,
} from "lucide-react";
import { useRouter } from "next/navigation";
import { useState, useTransition } from "react";
import { saveDeliveries } from "@/features/admin-deliveries/actions/mutations/saveDeliveries";
import type { DeliveryCreationData } from "@/features/admin-deliveries/actions/queries/getDeliveryCreationData";
import { Button, Heading } from "@/features/shared/components";
import { DeliveryCard } from "./DeliveryCard";
import { EndClientSelectionModal } from "./EndClientSelectionModal";
import { SaveConfirmationDialog } from "./SaveConfirmationDialog";

type DeliveryState = {
  id?: string;
  label: string;
  driverId: string;
  vehicleId: string;
  endClientIds: string[];
};

type DeliveryCreationInterfaceProps = {
  initialData: DeliveryCreationData;
};

export function DeliveryCreationInterface({
  initialData,
}: DeliveryCreationInterfaceProps) {
  const router = useRouter();
  const [isPending, startTransition] = useTransition();
  const [showConfirmation, setShowConfirmation] = useState(false);
  const [isSelectionModalOpen, setIsSelectionModalOpen] = useState(false);
  const [selectedDeliveryIndex, setSelectedDeliveryIndex] = useState<
    number | null
  >(null);

  // Initialize deliveries from existing data
  const [deliveries, setDeliveries] = useState<DeliveryState[]>(() => {
    return initialData.existingDeliveries.map((d, index) => ({
      id: d.id,
      label: d.notes || `Tournée ${index + 1}`,
      driverId: d.driverId || "",
      vehicleId: d.vehicleId || "",
      endClientIds: d.stops
        .map((s) =>
          s.sourceRequestStopId
            ? initialData.endClients.find((ec) =>
                ec.requestStops.some((rs) => rs.id === s.sourceRequestStopId),
              )?.id
            : null,
        )
        .filter((id): id is string => id !== null),
    }));
  });

  const [deletedDeliveryIds, setDeletedDeliveryIds] = useState<string[]>([]);

  // Calculate assigned end clients
  const assignedEndClientIds = new Set(
    deliveries.flatMap((d) => d.endClientIds),
  );

  // Calculate available drivers
  const availableDrivers = initialData.drivers.filter((d) => d.vehicleId);
  const maxDeliveries = availableDrivers.length;
  const canAddDelivery = deliveries.length < maxDeliveries;

  // Add new delivery
  const addDelivery = () => {
    if (!canAddDelivery) return;
    setDeliveries((prev) => [
      ...prev,
      {
        label: `Tournée ${prev.length + 1}`,
        driverId: "",
        vehicleId: "",
        endClientIds: [],
      },
    ]);
  };

  // Remove delivery
  const removeDelivery = (index: number) => {
    const delivery = deliveries[index];
    if (delivery.id) {
      setDeletedDeliveryIds((prev) => [...prev, delivery.id as string]);
    }
    setDeliveries((prev) => prev.filter((_, i) => i !== index));
  };

  // Update delivery
  const updateDelivery = (index: number, updates: Partial<DeliveryState>) => {
    setDeliveries((prev) =>
      prev.map((d, i) => (i === index ? { ...d, ...updates } : d)),
    );
  };

  // Open selection modal for a delivery
  const openSelectionModal = (index: number) => {
    setSelectedDeliveryIndex(index);
    setIsSelectionModalOpen(true);
  };

  // Handle end client selection confirmation
  const handleEndClientSelectionConfirm = (selectedIds: string[]) => {
    if (selectedDeliveryIndex !== null) {
      updateDelivery(selectedDeliveryIndex, { endClientIds: selectedIds });
    }
  };

  // Handle save
  const handleSave = async () => {
    setShowConfirmation(false);

    startTransition(async () => {
      try {
        // Filter out empty deliveries
        const nonEmptyDeliveries = deliveries.filter(
          (d) => d.endClientIds.length > 0 && d.driverId && d.vehicleId,
        );

        // Map to request stop IDs
        const deliveriesToSave = nonEmptyDeliveries.map((d) => {
          const requestStopIds = d.endClientIds.flatMap((ecId) => {
            const endClient = initialData.endClients.find(
              (ec) => ec.id === ecId,
            );
            return endClient?.requestStops.map((rs) => rs.id) || [];
          });

          return {
            id: d.id,
            label: d.label,
            driverId: d.driverId,
            vehicleId: d.vehicleId,
            requestStopIds,
          };
        });

        await saveDeliveries({
          date: initialData.date,
          deliveries: deliveriesToSave,
          deletedDeliveryIds:
            deletedDeliveryIds.length > 0 ? deletedDeliveryIds : undefined,
        });

        router.push("/deliveries");
        router.refresh();
      } catch (error) {
        console.error("Save failed:", error);
        alert(
          error instanceof Error ? error.message : "Échec de la sauvegarde",
        );
      }
    });
  };

  const hasUnsavedChanges = deliveries.some((d) => d.endClientIds.length > 0);
  const allAssigned =
    assignedEndClientIds.size === initialData.endClients.length;
  const unassignedStops =
    initialData.summary.totalStops -
    deliveries
      .flatMap((d) => d.endClientIds)
      .flatMap((ecId) => {
        const endClient = initialData.endClients.find((ec) => ec.id === ecId);
        return endClient?.requestStops || [];
      }).length;

  return (
    <div className="space-y-3 sm:space-y-4">
      {/* Header - Mobile Optimized */}
      <div className="rounded-lg sm:rounded-xl border border-zinc-200 dark:border-zinc-700 bg-white dark:bg-zinc-900 p-3 sm:p-4">
        <div className="space-y-3">
          {/* Title Row */}
          <div className="flex items-start justify-between gap-3">
            <div className="flex-1 min-w-0">
              <Heading level={1} className="text-lg sm:text-xl truncate">
                Organisation des Livraisons
              </Heading>
              <p className="text-xs text-zinc-600 dark:text-zinc-400 mt-0.5 hidden sm:block">
                Organisez les arrêts en livraisons et assignez les chauffeurs
              </p>
            </div>
            <Button
              onClick={() => setShowConfirmation(true)}
              disabled={isPending || !hasUnsavedChanges}
              className="shrink-0 !px-3 sm:!px-4"
            >
              <CheckCircle2Icon className="h-4 w-4 sm:mr-2" />
              <span className="hidden sm:inline">Sauvegarder</span>
            </Button>
          </div>

          {/* Summary Stats - Mobile Stacked, Desktop Inline */}
          <div className="flex flex-col sm:flex-row sm:items-center gap-2 sm:gap-4 text-xs text-zinc-600 dark:text-zinc-400">
            <div className="flex items-center gap-1.5">
              <BuildingIcon className="h-3.5 w-3.5 shrink-0" />
              <span className="truncate">
                <strong className="font-semibold text-zinc-900 dark:text-white">
                  {initialData.summary.totalRequests}
                </strong>{" "}
                client{initialData.summary.totalRequests > 1 ? "s" : ""}
              </span>
            </div>
            <div className="hidden sm:block h-3 w-px bg-zinc-300 dark:bg-zinc-700" />
            <div className="flex items-center gap-1.5">
              <PackageIcon className="h-3.5 w-3.5 shrink-0" />
              <span className="truncate">
                <strong className="font-semibold text-zinc-900 dark:text-white">
                  {initialData.endClients.length}
                </strong>{" "}
                adresse{initialData.endClients.length > 1 ? "s" : ""}
              </span>
            </div>
            <div className="hidden sm:block h-3 w-px bg-zinc-300 dark:bg-zinc-700" />
            <div className="flex items-center gap-1.5">
              {allAssigned ? (
                <CheckCircle2Icon className="h-3.5 w-3.5 text-green-600 dark:text-green-500 shrink-0" />
              ) : (
                <AlertCircleIcon className="h-3.5 w-3.5 text-amber-600 dark:text-amber-500 shrink-0" />
              )}
              <span className="truncate">
                <strong className="font-semibold text-zinc-900 dark:text-white">
                  {allAssigned
                    ? initialData.summary.totalStops
                    : unassignedStops}
                </strong>{" "}
                {allAssigned
                  ? "arrêts assignés"
                  : `à assigner sur ${initialData.summary.totalStops}`}
              </span>
            </div>
          </div>
        </div>
      </div>

      {/* Deliveries Interface */}
      <div className="space-y-3 sm:space-y-4">
        {deliveries.map((delivery, index) => {
          // Get driver IDs selected by other deliveries (excluding current one)
          const selectedDriverIds = deliveries
            .filter((_, i) => i !== index)
            .map((d) => d.driverId)
            .filter(Boolean);

          return (
            <DeliveryCard
              key={delivery.id || `new-delivery-${index}`}
              delivery={delivery}
              deliveryIndex={index}
              endClients={initialData.endClients.filter((ec) =>
                delivery.endClientIds.includes(ec.id),
              )}
              drivers={initialData.drivers}
              selectedDriverIds={selectedDriverIds}
              onUpdate={(updates) => updateDelivery(index, updates)}
              onRemove={() => removeDelivery(index)}
              onOpenSelectionModal={() => openSelectionModal(index)}
            />
          );
        })}

        {/* Add Delivery Button - Mobile Optimized */}
        <button
          type="button"
          onClick={addDelivery}
          disabled={!canAddDelivery}
          className={`w-full rounded-lg sm:rounded-xl border-2 border-dashed p-4 sm:p-6 transition-all duration-200 touch-manipulation ${
            canAddDelivery
              ? "border-zinc-300 dark:border-zinc-700 hover:border-blue-400 dark:hover:border-blue-600 hover:bg-blue-50 dark:hover:bg-blue-950/20 active:bg-blue-100 dark:active:bg-blue-950/30 cursor-pointer"
              : "border-zinc-200 dark:border-zinc-800 bg-zinc-50 dark:bg-zinc-900 cursor-not-allowed opacity-60"
          } group`}
        >
          <div className="flex flex-col items-center justify-center gap-2">
            <div className="flex items-center gap-2 sm:gap-3">
              <div
                className={`p-1.5 sm:p-2 rounded-lg ${
                  canAddDelivery
                    ? "bg-zinc-100 dark:bg-zinc-800 group-hover:bg-blue-100 dark:group-hover:bg-blue-900/30"
                    : "bg-zinc-200 dark:bg-zinc-850"
                } transition-colors`}
              >
                <PlusIcon
                  className={`h-4 w-4 sm:h-5 sm:w-5 ${
                    canAddDelivery
                      ? "text-zinc-600 dark:text-zinc-400 group-hover:text-blue-600 dark:group-hover:text-blue-400"
                      : "text-zinc-400 dark:text-zinc-600"
                  } transition-colors`}
                />
              </div>
              <span
                className={`text-sm font-semibold ${
                  canAddDelivery
                    ? "text-zinc-700 dark:text-zinc-300 group-hover:text-blue-700 dark:group-hover:text-blue-300"
                    : "text-zinc-500 dark:text-zinc-500"
                } transition-colors`}
              >
                Ajouter une Tournée
              </span>
            </div>
            {!canAddDelivery && (
              <p className="text-xs text-center text-zinc-500 dark:text-zinc-400 px-2">
                {availableDrivers.length === 0
                  ? "Aucun chauffeur avec véhicule disponible"
                  : `Tous les chauffeurs sont assignés (${deliveries.length}/${maxDeliveries})`}
              </p>
            )}
          </div>
        </button>
      </div>

      {/* End Client Selection Modal */}
      {selectedDeliveryIndex !== null && (
        <EndClientSelectionModal
          isOpen={isSelectionModalOpen}
          onClose={() => setIsSelectionModalOpen(false)}
          endClients={initialData.endClients}
          currentlyAssignedIds={deliveries[selectedDeliveryIndex].endClientIds}
          allAssignedIds={Array.from(assignedEndClientIds)}
          onConfirm={handleEndClientSelectionConfirm}
        />
      )}

      {/* Confirmation Dialog */}
      {showConfirmation && (
        <SaveConfirmationDialog
          deliveries={deliveries.filter((d) => d.endClientIds.length > 0)}
          endClients={initialData.endClients}
          onConfirm={handleSave}
          onCancel={() => setShowConfirmation(false)}
        />
      )}
    </div>
  );
}
