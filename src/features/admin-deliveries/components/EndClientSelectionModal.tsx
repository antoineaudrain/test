"use client";

import {
  createColumnHelper,
  flexRender,
  getCoreRowModel,
  getSortedRowModel,
  type SortingState,
  useReactTable,
} from "@tanstack/react-table";
import clsx from "clsx";
import { SearchIcon } from "lucide-react";
import { useCallback, useEffect, useMemo, useState } from "react";
import type { DeliveryRequestStopWithDetails } from "@/features/delivery-requests/types";
import {
  Button,
  Checkbox,
  Dialog,
  DialogActions,
  DialogBody,
  DialogDescription,
  DialogTitle,
  Strong,
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
  TableSortIndicator,
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

type EndClientRow = {
  id: string;
  name: string;
  address: string;
  stopCount: number;
  isAssignedToThisDelivery: boolean;
  isAssignedToOtherDelivery: boolean;
};

type EndClientSelectionModalProps = {
  isOpen: boolean;
  onClose: () => void;
  endClients: EndClient[];
  currentlyAssignedIds: string[];
  allAssignedIds: string[];
  onConfirm: (selectedIds: string[]) => void;
};

const columnHelper = createColumnHelper<EndClientRow>();

export function EndClientSelectionModal({
  isOpen,
  onClose,
  endClients,
  currentlyAssignedIds,
  allAssignedIds,
  onConfirm,
}: EndClientSelectionModalProps) {
  const [searchQuery, setSearchQuery] = useState("");
  const [sorting, setSorting] = useState<SortingState>([]);
  const [selectedIds, setSelectedIds] = useState<Set<string>>(new Set());

  // Initialize selection state when modal opens
  useEffect(() => {
    if (isOpen) {
      setSelectedIds(new Set(currentlyAssignedIds));
      setSearchQuery("");
    }
  }, [isOpen, currentlyAssignedIds]);

  // Transform end clients to rows
  const rows: EndClientRow[] = useMemo(
    () =>
      endClients.map((ec) => ({
        id: ec.id,
        name: ec.name,
        address: ec.address.formattedAddress,
        stopCount: ec.requestStops.length,
        isAssignedToThisDelivery: currentlyAssignedIds.includes(ec.id),
        isAssignedToOtherDelivery:
          allAssignedIds.includes(ec.id) &&
          !currentlyAssignedIds.includes(ec.id),
      })),
    [endClients, currentlyAssignedIds, allAssignedIds],
  );

  // Filter rows by search query
  const filteredRows = useMemo(() => {
    if (!searchQuery) return rows;
    const query = searchQuery.toLowerCase();
    return rows.filter(
      (row) =>
        row.name.toLowerCase().includes(query) ||
        row.address.toLowerCase().includes(query),
    );
  }, [rows, searchQuery]);

  const toggleSelection = useCallback((id: string, isDisabled: boolean) => {
    if (isDisabled) return;
    setSelectedIds((prev) => {
      const next = new Set(prev);
      if (next.has(id)) {
        next.delete(id);
      } else {
        next.add(id);
      }
      return next;
    });
  }, []);

  const handleConfirm = () => {
    onConfirm(Array.from(selectedIds));
    onClose();
  };

  const columns = useMemo(
    () => [
      columnHelper.display({
        id: "checkbox",
        header: () => <Text>Sélection</Text>,
        cell: ({ row }) => {
          const isDisabled = row.original.isAssignedToOtherDelivery;
          return (
            <Checkbox
              checked={selectedIds.has(row.original.id)}
              disabled={isDisabled}
              onChange={() => toggleSelection(row.original.id, isDisabled)}
            />
          );
        },
        enableSorting: false,
      }),
      columnHelper.accessor("name", {
        header: () => <Text>Client</Text>,
        cell: (props) => <Strong>{props.getValue()}</Strong>,
        enableSorting: true,
        sortingFn: (a, b) =>
          a.original.name.localeCompare(b.original.name, "fr", {
            numeric: true,
            sensitivity: "base",
          }),
      }),
      columnHelper.accessor("address", {
        header: () => <Text>Adresse</Text>,
        cell: (props) => (
          <Text className="text-sm line-clamp-2">{props.getValue()}</Text>
        ),
        enableSorting: true,
        sortingFn: (a, b) =>
          a.original.address.localeCompare(b.original.address, "fr", {
            numeric: true,
            sensitivity: "base",
          }),
      }),
      columnHelper.accessor("stopCount", {
        header: () => <Text>Arrêts</Text>,
        cell: (props) => (
          <Text className="font-semibold">{props.getValue()}</Text>
        ),
        enableSorting: true,
      }),
      columnHelper.display({
        id: "status",
        header: () => <Text>Statut</Text>,
        cell: ({ row }) => {
          if (row.original.isAssignedToOtherDelivery) {
            return (
              <span className="inline-flex items-center px-2 py-1 bg-zinc-100 dark:bg-zinc-800 text-zinc-600 dark:text-zinc-400 text-xs font-medium rounded">
                Déjà assigné
              </span>
            );
          }
          return null;
        },
        enableSorting: false,
      }),
    ],
    [selectedIds, toggleSelection],
  );

  const table = useReactTable({
    data: filteredRows,
    columns,
    state: { sorting },
    onSortingChange: setSorting,
    getCoreRowModel: getCoreRowModel(),
    getSortedRowModel: getSortedRowModel(),
  });

  const selectedCount = selectedIds.size;

  return (
    <Dialog open={isOpen} onClose={onClose} size="4xl">
      <DialogTitle className="text-base sm:text-lg">
        Sélectionner les clients finaux
      </DialogTitle>
      <DialogDescription className="text-xs sm:text-sm">
        Choisissez les clients finaux à assigner à cette tournée
      </DialogDescription>

      <DialogBody>
        {/* Search Input - Mobile Optimized */}
        <div className="mb-3 sm:mb-4">
          <div className="relative">
            <SearchIcon className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-zinc-400 pointer-events-none" />
            <input
              type="text"
              placeholder="Rechercher..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="w-full pl-10 pr-4 py-3 sm:py-2.5 border-2 border-zinc-300 dark:border-zinc-700 rounded-lg sm:rounded-xl bg-white dark:bg-zinc-800 text-sm focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-all"
            />
          </div>
        </div>

        {/* Desktop: Table layout */}
        <div className="hidden sm:block">
          <Table
            striped
            dense
            className="rounded-2xl border border-zinc-950/10 dark:border-white/10 overflow-hidden"
          >
            <TableHead>
              {table.getHeaderGroups().map((headerGroup) => (
                <TableRow key={headerGroup.id}>
                  {headerGroup.headers.map((header, index, arr) => {
                    const canSort = header.column.getCanSort();
                    const sortDirection = header.column.getIsSorted();

                    return (
                      <TableHeader
                        key={header.id}
                        className={clsx(
                          canSort &&
                            "cursor-pointer select-none hover:bg-zinc-50 dark:hover:bg-zinc-800",
                          !index && "pl-6!",
                          index === arr.length - 1 && "pr-6!",
                        )}
                        onClick={
                          canSort
                            ? header.column.getToggleSortingHandler()
                            : undefined
                        }
                      >
                        <div className="flex items-center gap-2">
                          {flexRender(
                            header.column.columnDef.header,
                            header.getContext(),
                          )}
                          {canSort && (
                            <TableSortIndicator
                              sortDirection={sortDirection || undefined}
                            />
                          )}
                        </div>
                      </TableHeader>
                    );
                  })}
                </TableRow>
              ))}
            </TableHead>

            <TableBody>
              {!table.getRowModel().rows.length && (
                <TableRow>
                  <TableCell colSpan={columns.length}>
                    <div className="text-center py-8">
                      <Text className="text-zinc-500 dark:text-zinc-400">
                        Aucun client trouvé
                      </Text>
                    </div>
                  </TableCell>
                </TableRow>
              )}

              {table.getRowModel().rows.map((row) => (
                <TableRow key={row.id}>
                  {row.getVisibleCells().map((cell, index, arr) => (
                    <TableCell
                      key={cell.id}
                      className={clsx(
                        index === 0 && "pl-6!",
                        index === arr.length - 1 && "pr-6!",
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

        {/* Mobile: Card layout - Touch Optimized */}
        <div className="sm:hidden space-y-2.5 max-h-[50vh] overflow-y-auto -mx-1 px-1">
          {!filteredRows.length && (
            <div className="text-center py-12">
              <Text className="text-sm text-zinc-500 dark:text-zinc-400">
                Aucun client trouvé
              </Text>
            </div>
          )}

          {filteredRows.map((row) => {
            const isDisabled = row.isAssignedToOtherDelivery;
            const isSelected = selectedIds.has(row.id);

            return (
              <div
                key={row.id}
                className={clsx(
                  "rounded-lg border-2 p-3 transition-all",
                  isDisabled &&
                    "opacity-60 bg-zinc-50 dark:bg-zinc-900 border-zinc-200 dark:border-zinc-700",
                  !isDisabled &&
                    isSelected &&
                    "border-blue-300 dark:border-blue-700 bg-blue-50/50 dark:bg-blue-950/20",
                  !isDisabled &&
                    !isSelected &&
                    "border-zinc-200 dark:border-zinc-700",
                )}
              >
                {/* Selection checkbox + client name */}
                <div className="flex items-start gap-3">
                  <button
                    type="button"
                    onClick={() => toggleSelection(row.id, isDisabled)}
                    disabled={isDisabled}
                    className="p-2 -m-2 rounded-lg touch-manipulation min-w-[44px] min-h-[44px] flex items-center justify-center"
                    aria-label={
                      isSelected
                        ? `Désélectionner ${row.name}`
                        : `Sélectionner ${row.name}`
                    }
                  >
                    <Checkbox
                      checked={isSelected}
                      disabled={isDisabled}
                      onChange={() => {}}
                    />
                  </button>
                  <div className="flex-1 min-w-0 pt-1">
                    <div className="flex items-center gap-2 mb-1">
                      <Strong className="block text-sm">{row.name}</Strong>
                      <span className="shrink-0 px-1.5 py-0.5 bg-blue-100 dark:bg-blue-900/30 text-blue-700 dark:text-blue-300 text-xs font-medium rounded">
                        {row.stopCount}
                      </span>
                    </div>
                    <Text className="text-xs text-zinc-600 dark:text-zinc-400 line-clamp-2 leading-relaxed">
                      {row.address}
                    </Text>
                    {isDisabled && (
                      <span className="inline-block mt-2 px-2 py-1 bg-zinc-100 dark:bg-zinc-800 text-zinc-600 dark:text-zinc-400 text-xs font-medium rounded">
                        Déjà assigné
                      </span>
                    )}
                  </div>
                </div>
              </div>
            );
          })}
        </div>

        {/* Selection summary - Mobile Optimized */}
        <div className="mt-3 sm:mt-4 p-3 bg-blue-50 dark:bg-blue-950/30 rounded-lg sm:rounded-xl border border-blue-200 dark:border-blue-800">
          <Text className="text-xs sm:text-sm text-blue-900 dark:text-blue-100">
            <strong className="font-semibold">{selectedCount}</strong> client
            {selectedCount > 1 ? "s" : ""} sélectionné
            {selectedCount > 1 ? "s" : ""}
          </Text>
        </div>
      </DialogBody>

      <DialogActions className="gap-2 sm:gap-3">
        <Button outline onClick={onClose} className="min-h-[44px] sm:min-h-0">
          Annuler
        </Button>
        <Button onClick={handleConfirm} className="min-h-[44px] sm:min-h-0">
          Confirmer
        </Button>
      </DialogActions>
    </Dialog>
  );
}
