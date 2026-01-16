"use client";

import {
  closestCenter,
  DndContext,
  type DragEndEvent,
  DragOverlay,
  type DragStartEvent,
} from "@dnd-kit/core";
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
import { DeliveryContainer } from "./DeliveryContainer";
import { EndClientCard } from "./EndClientCard";
import { SaveConfirmationDialog } from "./SaveConfirmationDialog";
import { UnassignedPool } from "./UnassignedPool";

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
  const [activeId, setActiveId] = useState<string | null>(null);
  const [showConfirmation, setShowConfirmation] = useState(false);

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

  // Calculate unassigned end clients
  const assignedEndClientIds = new Set(
    deliveries.flatMap((d) => d.endClientIds),
  );
  const unassignedEndClients = initialData.endClients.filter(
    (ec) => !assignedEndClientIds.has(ec.id),
  );

  // Handle drag start
  const handleDragStart = (event: DragStartEvent) => {
    setActiveId(event.active.id as string);
  };

  // Handle drag end
  const handleDragEnd = (event: DragEndEvent) => {
    const { active, over } = event;
    setActiveId(null);

    if (!over) return;

    const endClientId = active.id as string;
    const targetContainer = over.id as string;

    // Find which delivery (if any) currently has this end client
    const sourceDeliveryIndex = deliveries.findIndex((d) =>
      d.endClientIds.includes(endClientId),
    );

    // Remove from source
    if (sourceDeliveryIndex !== -1) {
      setDeliveries((prev) =>
        prev.map((d, i) =>
          i === sourceDeliveryIndex
            ? {
                ...d,
                endClientIds: d.endClientIds.filter((id) => id !== endClientId),
              }
            : d,
        ),
      );
    }

    // Add to target (if not unassigned pool)
    if (targetContainer !== "unassigned") {
      const targetIndex = deliveries.findIndex(
        (_d, i) => `delivery-${i}` === targetContainer,
      );
      if (targetIndex !== -1) {
        setDeliveries((prev) =>
          prev.map((d, i) =>
            i === targetIndex
              ? { ...d, endClientIds: [...d.endClientIds, endClientId] }
              : d,
          ),
        );
      }
    }
  };

  // Add new delivery
  const addDelivery = () => {
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

  // Change date
  const _changeDate = (newDate: string) => {
    router.push(`/deliveries/new?date=${newDate}`);
  };

  const activeEndClient = activeId
    ? initialData.endClients.find((ec) => ec.id === activeId)
    : null;

  const hasUnsavedChanges = deliveries.some((d) => d.endClientIds.length > 0);
  const allAssigned = initialData.summary.unassignedStops === 0;

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="rounded-2xl bg-gradient-to-br from-white to-zinc-50 dark:from-zinc-900 dark:to-zinc-850 border-2 border-zinc-200 dark:border-zinc-700 p-6 shadow-sm">
        <div className="flex flex-col gap-4 lg:flex-row lg:items-start lg:justify-between">
          <div className="flex-1">
            <Heading level={1} className="mb-1">
              Organisation des Livraisons
            </Heading>
            <p className="text-sm text-zinc-600 dark:text-zinc-400 mb-4">
              Organisez les arrêts en livraisons et assignez les chauffeurs
            </p>

            {/* Date Picker */}
            {/*<div className="flex items-center gap-3">*/}
            {/*  <div className="p-2 rounded-lg bg-blue-100 dark:bg-blue-900/30">*/}
            {/*    <CalendarIcon className="h-5 w-5 text-blue-600 dark:text-blue-400" />*/}
            {/*  </div>*/}
            {/*  <div>*/}
            {/*    <label className="text-xs font-semibold text-zinc-700 dark:text-zinc-300 block mb-1">*/}
            {/*      Date de livraison*/}
            {/*    </label>*/}
            {/*    <input*/}
            {/*      type="date"*/}
            {/*      value={initialData.date}*/}
            {/*      onChange={(e) => changeDate(e.target.value)}*/}
            {/*      className="border-2 border-zinc-300 dark:border-zinc-700 rounded-xl px-3 py-2 text-sm font-medium dark:bg-zinc-800 focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-all"*/}
            {/*    />*/}
            {/*  </div>*/}
            {/*</div>*/}
          </div>

          {/* Summary Stats */}
          <div className="flex flex-col sm:flex-row items-stretch sm:items-center gap-3 w-full lg:w-auto">
            {/* Client Companies Card */}
            <div className="rounded-xl bg-gradient-to-br from-purple-50 to-purple-100 dark:from-purple-950/30 dark:to-purple-900/20 border-2 border-purple-200 dark:border-purple-800 p-4 flex-1 min-w-0 lg:flex-none lg:min-w-[140px]">
              <div className="flex items-center gap-2 mb-1">
                <BuildingIcon className="h-4 w-4 text-purple-600 dark:text-purple-400" />
                <span className="text-xs font-semibold text-purple-700 dark:text-purple-300">
                  Clients
                </span>
              </div>
              <div className="text-2xl font-bold text-purple-900 dark:text-purple-100">
                {initialData.summary.totalRequests}
              </div>
              <div className="text-xs text-purple-600 dark:text-purple-400">
                entreprise{initialData.summary.totalRequests > 1 ? "s" : ""}
              </div>
            </div>

            {/* End Client Companies Card */}
            <div className="rounded-xl bg-gradient-to-br from-blue-50 to-blue-100 dark:from-blue-950/30 dark:to-blue-900/20 border-2 border-blue-200 dark:border-blue-800 p-4 flex-1 min-w-0 lg:flex-none lg:min-w-[140px]">
              <div className="flex items-center gap-2 mb-1">
                <PackageIcon className="h-4 w-4 text-blue-600 dark:text-blue-400" />
                <span className="text-xs font-semibold text-blue-700 dark:text-blue-300">
                  Clients finaux
                </span>
              </div>
              <div className="text-2xl font-bold text-blue-900 dark:text-blue-100">
                {initialData.endClients.length}
              </div>
              <div className="text-xs text-blue-600 dark:text-blue-400">
                adresse{initialData.endClients.length > 1 ? "s" : ""}
              </div>
            </div>

            {/* Total Stops with Assigned/Remaining Status */}
            <div
              className={`rounded-xl p-4 flex-1 min-w-0 lg:flex-none lg:min-w-[140px] border-2 transition-all ${
                allAssigned
                  ? "bg-gradient-to-br from-green-50 to-green-100 dark:from-green-950/30 dark:to-green-900/20 border-green-200 dark:border-green-800"
                  : "bg-gradient-to-br from-amber-50 to-amber-100 dark:from-amber-950/30 dark:to-amber-900/20 border-amber-200 dark:border-amber-800"
              }`}
            >
              <div className="flex items-center gap-2 mb-1">
                {allAssigned ? (
                  <>
                    <CheckCircle2Icon className="h-4 w-4 text-green-600 dark:text-green-400" />
                    <span className="text-xs font-semibold text-green-700 dark:text-green-300">
                      Assignés
                    </span>
                  </>
                ) : (
                  <>
                    <AlertCircleIcon className="h-4 w-4 text-amber-600 dark:text-amber-400" />
                    <span className="text-xs font-semibold text-amber-700 dark:text-amber-300">
                      À assigner
                    </span>
                  </>
                )}
              </div>
              <div
                className={`text-2xl font-bold ${
                  allAssigned
                    ? "text-green-900 dark:text-green-100"
                    : "text-amber-900 dark:text-amber-100"
                }`}
              >
                {allAssigned
                  ? initialData.summary.totalStops
                  : initialData.summary.unassignedStops}
              </div>
              <div
                className={`text-xs ${
                  allAssigned
                    ? "text-green-600 dark:text-green-400"
                    : "text-amber-600 dark:text-amber-400"
                }`}
              >
                {allAssigned
                  ? "arrêts"
                  : `arrêt${initialData.summary.unassignedStops > 1 ? "s" : ""} sur ${initialData.summary.totalStops}`}
              </div>
            </div>

            {/* Save Button */}
            <Button
              onClick={() => setShowConfirmation(true)}
              disabled={isPending || !hasUnsavedChanges}
              className={`w-full lg:w-auto lg:h-[108px] py-4 lg:py-0 lg:px-8 text-base font-semibold shadow-lg transition-all ${
                hasUnsavedChanges
                  ? "bg-gradient-to-br from-blue-600 to-blue-700 hover:from-blue-700 hover:to-blue-800 dark:from-blue-500 dark:to-blue-600"
                  : ""
              }`}
            >
              <div className="flex flex-row lg:flex-col items-center gap-2 lg:gap-1">
                <CheckCircle2Icon className="h-6 w-6" />
                <span>Sauvegarder</span>
              </div>
            </Button>
          </div>
        </div>
      </div>

      {/* Drag and Drop Interface */}
      <DndContext
        collisionDetection={closestCenter}
        onDragStart={handleDragStart}
        onDragEnd={handleDragEnd}
      >
        <div className="grid grid-cols-1 lg:grid-cols-4 gap-6">
          {/* Unassigned Pool - appears below deliveries on mobile */}
          <div className="order-2 lg:order-1 lg:col-span-1">
            <UnassignedPool endClients={unassignedEndClients} />
          </div>

          {/* Delivery Containers - appears first on mobile */}
          <div className="order-1 lg:order-2 lg:col-span-3 space-y-4">
            {deliveries.map((delivery, index) => {
              // Get driver IDs selected by other deliveries (excluding current one)
              const selectedDriverIds = deliveries
                .filter((_, i) => i !== index)
                .map((d) => d.driverId)
                .filter(Boolean);

              return (
                <DeliveryContainer
                  key={delivery.id || `new-delivery-${index}`}
                  id={`delivery-${index}`}
                  delivery={delivery}
                  endClients={initialData.endClients.filter((ec) =>
                    delivery.endClientIds.includes(ec.id),
                  )}
                  drivers={initialData.drivers}
                  selectedDriverIds={selectedDriverIds}
                  onUpdate={(updates) => updateDelivery(index, updates)}
                  onRemove={() => removeDelivery(index)}
                />
              );
            })}

            {/* Add Delivery Button */}
            <button
              type="button"
              onClick={addDelivery}
              className="w-full rounded-2xl border-2 border-dashed border-zinc-300 dark:border-zinc-700 p-6 transition-all duration-200 hover:border-blue-400 dark:hover:border-blue-600 hover:bg-gradient-to-br hover:from-blue-50 hover:to-blue-100 dark:hover:from-blue-950/20 dark:hover:to-blue-900/10 hover:shadow-md group"
            >
              <div className="flex items-center justify-center gap-3">
                <div className="p-2 rounded-lg bg-zinc-100 dark:bg-zinc-800 group-hover:bg-blue-100 dark:group-hover:bg-blue-900/30 transition-colors">
                  <PlusIcon className="h-5 w-5 text-zinc-600 dark:text-zinc-400 group-hover:text-blue-600 dark:group-hover:text-blue-400 transition-colors" />
                </div>
                <span className="text-sm font-semibold text-zinc-700 dark:text-zinc-300 group-hover:text-blue-700 dark:group-hover:text-blue-300 transition-colors">
                  Ajouter une Tournée
                </span>
              </div>
            </button>
          </div>
        </div>

        {/* Drag Overlay */}
        <DragOverlay>
          {activeEndClient && (
            <EndClientCard endClient={activeEndClient} isDragging />
          )}
        </DragOverlay>
      </DndContext>

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
