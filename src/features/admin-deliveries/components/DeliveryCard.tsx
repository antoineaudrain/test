"use client";

import {
  createColumnHelper,
  flexRender,
  getCoreRowModel,
  useReactTable,
} from "@tanstack/react-table";
import clsx from "clsx";
import {
  AlertCircleIcon,
  CheckCircle2Icon,
  ChevronDownIcon,
  MapPinIcon,
  Package2Icon,
  PlusIcon,
  Trash2Icon,
  UserIcon,
  XIcon,
} from "lucide-react";
import { useCallback, useMemo, useState } from "react";
import type { DeliveryRequestStopWithDetails } from "@/features/delivery-requests/types";
import {
  Button,
  Strong,
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
  Text,
} from "@/features/shared/components";

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
  deliveryStatus?: string;
};

type Driver = {
  id: string;
  firstName: string;
  lastName: string;
  vehicleId: string | null;
};

type DeliveryCardProps = {
  delivery: DeliveryState;
  deliveryIndex: number;
  endClients: EndClient[];
  drivers: Driver[];
  selectedDriverIds: string[];
  onUpdate: (updates: Partial<DeliveryState>) => void;
  onRemove: () => void;
  onOpenSelectionModal: () => void;
};

type EndClientRow = {
  id: string;
  name: string;
  address: string;
  stopCount: number;
};

const columnHelper = createColumnHelper<EndClientRow>();

export function DeliveryCard({
  delivery,
  deliveryIndex,
  endClients,
  drivers,
  selectedDriverIds,
  onUpdate,
  onRemove,
  onOpenSelectionModal,
}: DeliveryCardProps) {
  const deliveryNumber = deliveryIndex + 1;
  const [isExpanded, setIsExpanded] = useState(false);

  // Check if delivery is started or completed
  const isDisabled =
    delivery.deliveryStatus === "IN_PROGRESS" ||
    delivery.deliveryStatus === "COMPLETED";

  // Filter to only show drivers who have a vehicle assigned
  const availableDrivers = drivers.filter((d) => d.vehicleId);

  const totalStops = endClients.reduce(
    (sum, ec) => sum + ec.requestStops.length,
    0,
  );
  const isValid =
    delivery.driverId && delivery.vehicleId && endClients.length > 0;
  const isEmpty = endClients.length === 0;

  const removeEndClient = useCallback(
    (endClientId: string) => {
      onUpdate({
        endClientIds: delivery.endClientIds.filter((id) => id !== endClientId),
      });
    },
    [delivery.endClientIds, onUpdate],
  );

  // Transform end clients to rows
  const rows: EndClientRow[] = useMemo(
    () =>
      endClients.map((ec) => ({
        id: ec.id,
        name: ec.name,
        address: ec.address.formattedAddress,
        stopCount: ec.requestStops.length,
      })),
    [endClients],
  );

  const columns = useMemo(
    () => [
      columnHelper.accessor("name", {
        header: () => <Text>Client</Text>,
        cell: (props) => <Strong>{props.getValue()}</Strong>,
      }),
      columnHelper.accessor("address", {
        header: () => <Text>Adresse</Text>,
        cell: (props) => (
          <Text className="text-sm line-clamp-1">{props.getValue()}</Text>
        ),
      }),
      columnHelper.accessor("stopCount", {
        header: () => <Text>Arrêts</Text>,
        cell: (props) => (
          <Text className="font-semibold">{props.getValue()}</Text>
        ),
      }),
      columnHelper.display({
        id: "actions",
        header: () => null,
        cell: ({ row }) => (
          <button
            type="button"
            onClick={() => removeEndClient(row.original.id)}
            disabled={isDisabled}
            className="p-1.5 rounded-lg text-zinc-400 hover:text-red-600 hover:bg-red-50 dark:hover:bg-red-950/30 transition-all disabled:opacity-50 disabled:cursor-not-allowed"
            aria-label={`Retirer ${row.original.name}`}
          >
            <XIcon className="h-4 w-4" />
          </button>
        ),
      }),
    ],
    [removeEndClient, isDisabled],
  );

  const table = useReactTable({
    data: rows,
    columns,
    getCoreRowModel: getCoreRowModel(),
  });

  return (
    <div className="rounded-lg sm:rounded-xl border-2 border-zinc-300 dark:border-zinc-700 bg-gradient-to-br from-white to-zinc-50 dark:from-zinc-900 dark:to-zinc-850 p-3 sm:p-4 transition-all duration-300 ease-out">
      {/* Header - Mobile Optimized */}
      <div className="flex items-center gap-2 mb-2.5 sm:mb-3">
        <h3 className="text-sm sm:text-base font-semibold text-zinc-900 dark:text-white flex-1 truncate">
          Tournée {deliveryNumber}
        </h3>
        <div className="flex items-center gap-1 sm:gap-1.5 shrink-0">
          {isValid && (
            <div className="flex items-center gap-0.5 sm:gap-1 px-1.5 sm:px-2 py-0.5 bg-green-100 dark:bg-green-900/30 rounded text-xs font-medium text-green-700 dark:text-green-300">
              <CheckCircle2Icon className="h-3 w-3" />
              <span className="hidden sm:inline">Prêt</span>
            </div>
          )}
          {!isEmpty && (
            <div className="flex items-center gap-0.5 sm:gap-1 px-1.5 sm:px-2 py-0.5 bg-blue-100 dark:bg-blue-900/30 rounded text-xs font-semibold text-blue-700 dark:text-blue-300">
              <Package2Icon className="h-3 w-3" />
              {totalStops}
            </div>
          )}
          <Button
            outline
            onClick={onRemove}
            disabled={isDisabled}
            className="text-red-600 hover:text-red-700 hover:bg-red-50 dark:text-red-400 dark:hover:bg-red-950/30 !p-1 touch-manipulation"
          >
            <Trash2Icon className="h-3.5 w-3.5" />
          </Button>
        </div>
      </div>

      {/* Driver Selection - Mobile Optimized */}
      <div className="mb-2.5 sm:mb-3">
        <div className="flex items-center gap-1.5 sm:gap-2 mb-1.5">
          <UserIcon className="h-3.5 w-3.5 text-zinc-500 dark:text-zinc-400 shrink-0" />
          <label
            htmlFor={`driver-${deliveryIndex}`}
            className="text-xs font-semibold text-zinc-600 dark:text-zinc-400"
          >
            Chauffeur{" "}
            {!delivery.driverId && <span className="text-red-500">*</span>}
          </label>
        </div>
        <select
          id={`driver-${deliveryIndex}`}
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
          disabled={isDisabled}
          className="w-full border border-zinc-300 dark:border-zinc-700 rounded-lg px-3 py-2.5 sm:py-2 text-sm transition-all dark:bg-zinc-800 focus:ring-2 focus:ring-blue-500 focus:border-blue-500 appearance-none disabled:opacity-50 disabled:cursor-not-allowed"
        >
          <option value="">Sélectionner...</option>
          {availableDrivers.map((driver) => {
            const isSelected = selectedDriverIds.includes(driver.id);
            return (
              <option key={driver.id} value={driver.id} disabled={isSelected}>
                {driver.firstName} {driver.lastName}{" "}
                {isSelected ? "(Assigné)" : ""}
              </option>
            );
          })}
        </select>
      </div>

      {/* Validation Warning - Mobile Optimized */}
      {!isValid && !isEmpty && (
        <div className="flex items-center gap-2 p-2 mb-2.5 sm:mb-3 bg-amber-50 dark:bg-amber-950/30 border border-amber-200 dark:border-amber-800 rounded-lg">
          <AlertCircleIcon className="h-4 w-4 text-amber-600 dark:text-amber-400 shrink-0" />
          <p className="text-xs text-amber-800 dark:text-amber-200">
            Sélectionnez un chauffeur
          </p>
        </div>
      )}

      {/* Add Stops Button - Mobile Optimized */}
      <button
        type="button"
        onClick={onOpenSelectionModal}
        disabled={isDisabled}
        className="w-full mb-2.5 sm:mb-3 rounded-lg border-2 border-dashed border-zinc-300 dark:border-zinc-700 py-2.5 sm:py-2 transition-all hover:border-blue-400 dark:hover:border-blue-600 hover:bg-blue-50 dark:hover:bg-blue-950/20 active:bg-blue-100 dark:active:bg-blue-950/30 touch-manipulation group disabled:opacity-50 disabled:cursor-not-allowed disabled:hover:border-zinc-300 dark:disabled:hover:border-zinc-700 disabled:hover:bg-transparent"
      >
        <div className="flex items-center justify-center gap-1.5">
          <PlusIcon className="h-3.5 w-3.5 text-zinc-600 dark:text-zinc-400 group-hover:text-blue-600 dark:group-hover:text-blue-400 shrink-0" />
          <span className="text-xs sm:text-sm font-semibold text-zinc-700 dark:text-zinc-300 group-hover:text-blue-700 dark:group-hover:text-blue-300">
            Ajouter des arrêts
          </span>
        </div>
      </button>

      {/* Collapsible Stops List - Mobile Optimized */}
      {isEmpty ? (
        <div className="border border-dashed border-zinc-300 dark:border-zinc-700 rounded-lg py-5 sm:py-6 text-center">
          <Package2Icon className="h-5 w-5 sm:h-6 sm:w-6 mx-auto mb-1 sm:mb-1.5 text-zinc-300 dark:text-zinc-600" />
          <p className="text-xs font-medium text-zinc-500 dark:text-zinc-400">
            Aucun arrêt
          </p>
        </div>
      ) : (
        <div className="border border-zinc-200 dark:border-zinc-700 rounded-lg overflow-hidden">
          {/* Collapse Header - Touch Friendly */}
          <button
            type="button"
            onClick={() => setIsExpanded(!isExpanded)}
            className="w-full flex items-center justify-between p-3 sm:p-2.5 bg-zinc-50 dark:bg-zinc-800 hover:bg-zinc-100 dark:hover:bg-zinc-750 active:bg-zinc-200 dark:active:bg-zinc-700 transition-colors touch-manipulation"
          >
            <div className="flex items-center gap-2 min-w-0 flex-1">
              <MapPinIcon className="h-3.5 w-3.5 text-blue-600 dark:text-blue-400 shrink-0" />
              <span className="text-xs font-semibold text-zinc-900 dark:text-white truncate">
                {endClients.length} client{endClients.length > 1 ? "s" : ""} ·{" "}
                {totalStops} arrêt{totalStops > 1 ? "s" : ""}
              </span>
            </div>
            <ChevronDownIcon
              className={clsx(
                "h-4 w-4 text-zinc-600 dark:text-zinc-400 transition-transform shrink-0 ml-2",
                isExpanded && "rotate-180",
              )}
            />
          </button>

          {/* Collapsible Content */}
          {isExpanded && (
            <>
              {/* Desktop: Table */}
              <div className="hidden sm:block">
                <Table dense className="border-0">
                  <TableHead>
                    {table.getHeaderGroups().map((headerGroup) => (
                      <TableRow key={headerGroup.id}>
                        {headerGroup.headers.map((header, index, arr) => (
                          <TableHeader
                            key={header.id}
                            className={clsx(
                              index === 0 && "pl-3!",
                              index === arr.length - 1 && "pr-3!",
                            )}
                          >
                            {flexRender(
                              header.column.columnDef.header,
                              header.getContext(),
                            )}
                          </TableHeader>
                        ))}
                      </TableRow>
                    ))}
                  </TableHead>
                  <TableBody>
                    {table.getRowModel().rows.map((row) => (
                      <TableRow key={row.id}>
                        {row.getVisibleCells().map((cell, index, arr) => (
                          <TableCell
                            key={cell.id}
                            className={clsx(
                              index === 0 && "pl-3!",
                              index === arr.length - 1 && "pr-3!",
                            )}
                          >
                            {flexRender(
                              cell.column.columnDef.cell,
                              cell.getContext(),
                            )}
                          </TableCell>
                        ))}
                      </TableRow>
                    ))}
                  </TableBody>
                </Table>
              </div>

              {/* Mobile: Cards - Touch Optimized */}
              <div className="sm:hidden divide-y divide-zinc-200 dark:divide-zinc-700">
                {endClients.map((endClient) => {
                  const stopCount = endClient.requestStops.length;
                  return (
                    <div
                      key={endClient.id}
                      className="flex items-start gap-2 p-3"
                    >
                      <div className="flex-1 min-w-0">
                        <div className="flex items-center gap-1.5 mb-1">
                          <Strong className="text-sm truncate">
                            {endClient.name}
                          </Strong>
                          <span className="shrink-0 px-1.5 py-0.5 bg-blue-100 dark:bg-blue-900/30 text-blue-700 dark:text-blue-300 text-xs font-medium rounded">
                            {stopCount}
                          </span>
                        </div>
                        <Text className="text-xs text-zinc-500 dark:text-zinc-400 line-clamp-2 leading-relaxed">
                          {endClient.address.formattedAddress}
                        </Text>
                      </div>
                      <button
                        type="button"
                        onClick={() => removeEndClient(endClient.id)}
                        disabled={isDisabled}
                        className="shrink-0 p-2 -m-1 rounded-lg text-zinc-400 hover:text-red-600 hover:bg-red-50 dark:hover:bg-red-950/30 active:bg-red-100 dark:active:bg-red-950/40 transition-all touch-manipulation disabled:opacity-50 disabled:cursor-not-allowed"
                        aria-label={`Retirer ${endClient.name}`}
                      >
                        <XIcon className="h-4 w-4" />
                      </button>
                    </div>
                  );
                })}
              </div>
            </>
          )}
        </div>
      )}
    </div>
  );
}
