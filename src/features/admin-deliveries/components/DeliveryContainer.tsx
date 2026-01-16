"use client";

import { useDroppable } from "@dnd-kit/core";
import {
  AlertCircleIcon,
  CheckCircle2Icon,
  Package2Icon,
  Trash2Icon,
  UserIcon,
} from "lucide-react";
import type { DeliveryRequestStopWithDetails } from "@/features/delivery-requests/types";
import { Button } from "@/features/shared/components";
import { EndClientCard } from "./EndClientCard";

type EndClient = {
  id: string;
  name: string;
  address: {
    formattedAddress: string;
  };
  requestStops: DeliveryRequestStopWithDetails[];
};

type DeliveryState = {
  id?: string;
  label: string;
  driverId: string;
  vehicleId: string;
  endClientIds: string[];
};

type Driver = {
  id: string;
  firstName: string;
  lastName: string;
  vehicleId: string | null;
};

type DeliveryContainerProps = {
  id: string;
  delivery: DeliveryState;
  endClients: EndClient[];
  drivers: Driver[];
  selectedDriverIds: string[];
  onUpdate: (updates: Partial<DeliveryState>) => void;
  onRemove: () => void;
};

export function DeliveryContainer({
  id,
  delivery,
  endClients,
  drivers,
  selectedDriverIds,
  onUpdate,
  onRemove,
}: DeliveryContainerProps) {
  const { setNodeRef, isOver } = useDroppable({ id });

  // Extract index from id (e.g., "delivery-0" -> 0)
  const deliveryIndex = parseInt(id.split("-")[1] || "0", 10);
  const deliveryNumber = deliveryIndex + 1;

  // Filter to only show drivers who have a vehicle assigned
  const availableDrivers = drivers.filter((d) => d.vehicleId);

  const totalStops = endClients.reduce(
    (sum, ec) => sum + ec.requestStops.length,
    0,
  );
  const isValid =
    delivery.driverId && delivery.vehicleId && endClients.length > 0;
  const isEmpty = endClients.length === 0;

  return (
    <div
      ref={setNodeRef}
      className={`
        rounded-xl border-2 p-4 transition-all duration-300 ease-out
        ${
          isOver
            ? "border-blue-500 bg-gradient-to-br from-blue-50 to-blue-100 dark:from-blue-950/40 dark:to-blue-900/30 shadow-xl scale-[1.01]"
            : isValid
              ? "border-green-300 dark:border-green-700 bg-gradient-to-br from-white to-green-50 dark:from-zinc-900 dark:to-green-950/20 shadow-md"
              : "border-zinc-300 dark:border-zinc-700 bg-gradient-to-br from-white to-zinc-50 dark:from-zinc-900 dark:to-zinc-850"
        }
      `}
    >
      {/* Header */}
      <div className="flex items-center gap-3 mb-4">
        <h3 className="text-base font-semibold text-zinc-900 dark:text-white flex-1">
          Tournée {deliveryNumber}
        </h3>
        <div className="flex items-center gap-2">
          {isValid && (
            <div className="flex items-center gap-1.5 px-2 py-1 bg-green-100 dark:bg-green-900/30 rounded-lg">
              <CheckCircle2Icon className="h-3.5 w-3.5 text-green-600 dark:text-green-400" />
              <span className="text-xs font-medium text-green-700 dark:text-green-300">
                Prêt
              </span>
            </div>
          )}
          {!isEmpty && (
            <div className="flex items-center gap-1.5 px-2 py-1 bg-blue-100 dark:bg-blue-900/30 rounded-lg">
              <Package2Icon className="h-3.5 w-3.5 text-blue-600 dark:text-blue-400" />
              <span className="text-xs font-semibold text-blue-700 dark:text-blue-300">
                {totalStops}
              </span>
            </div>
          )}
          <Button
            outline
            onClick={onRemove}
            className="text-red-600 hover:text-red-700 hover:bg-red-50 dark:text-red-400 dark:hover:bg-red-950/30 !p-1.5"
          >
            <Trash2Icon className="h-4 w-4" />
          </Button>
        </div>
      </div>

      {/* Driver Selection */}
      <div className="mb-4">
        <label
          htmlFor={`driver-${id}`}
          className="flex items-center gap-2 text-sm font-semibold mb-2 text-zinc-700 dark:text-zinc-300"
        >
          <UserIcon className="h-4 w-4" />
          Chauffeur
          {!delivery.driverId && <span className="text-red-500">*</span>}
        </label>
        <select
          id={`driver-${id}`}
          value={delivery.driverId}
          onChange={(e) => {
            const driver = availableDrivers.find(
              (d) => d.id === e.target.value,
            );
            onUpdate({
              driverId: e.target.value,
              vehicleId: driver?.vehicleId || "",
            });
          }}
          className={`
            w-full border-2 rounded-xl px-4 py-3 sm:py-2.5 text-base sm:text-sm transition-all
            dark:bg-zinc-800 focus:ring-2 focus:ring-blue-500 focus:border-blue-500
            ${
              delivery.driverId
                ? "border-green-300 dark:border-green-700"
                : "border-zinc-300 dark:border-zinc-700"
            }
          `}
        >
          <option value="">Sélectionner un chauffeur...</option>
          {availableDrivers.length === 0 && (
            <option disabled>Aucun chauffeur avec véhicule disponible</option>
          )}
          {availableDrivers.map((driver) => {
            const isSelected = selectedDriverIds.includes(driver.id);
            return (
              <option key={driver.id} value={driver.id} disabled={isSelected}>
                {driver.firstName} {driver.lastName}{" "}
                {isSelected ? "(Déjà assigné)" : ""}
              </option>
            );
          })}
        </select>
        {availableDrivers.length === 0 && (
          <p className="text-sm text-amber-600 dark:text-amber-400 mt-1">
            Aucun chauffeur avec véhicule assigné. Assignez un véhicule aux
            employés dans les paramètres.
          </p>
        )}
      </div>

      {/* Validation Warning */}
      {!isValid && !isEmpty && (
        <div className="flex items-start gap-3 p-3 mb-4 bg-amber-50 dark:bg-amber-950/30 border border-amber-200 dark:border-amber-800 rounded-xl">
          <AlertCircleIcon className="h-5 w-5 text-amber-600 dark:text-amber-400 flex-shrink-0 mt-0.5" />
          <div className="text-sm text-amber-800 dark:text-amber-200">
            <strong className="font-semibold">Incomplet:</strong> Sélectionnez
            un chauffeur pour activer cette livraison
          </div>
        </div>
      )}

      {/* End Clients */}
      {isEmpty ? (
        <div className="border-2 border-dashed border-zinc-300 dark:border-zinc-700 rounded-xl p-12 text-center">
          <Package2Icon className="h-12 w-12 mx-auto mb-3 text-zinc-300 dark:text-zinc-600" />
          <p className="text-sm font-medium text-zinc-500 dark:text-zinc-400">
            Glissez des clients finaux ici
          </p>
          <p className="text-xs text-zinc-400 dark:text-zinc-500 mt-1">
            Faites glisser les clients finaux depuis la zone non assignés
          </p>
        </div>
      ) : (
        <div className="space-y-3">
          {endClients.map((endClient) => (
            <EndClientCard key={endClient.id} endClient={endClient} />
          ))}
        </div>
      )}
    </div>
  );
}
