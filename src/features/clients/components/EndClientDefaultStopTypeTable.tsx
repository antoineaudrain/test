"use client";

import {
  createColumnHelper,
  flexRender,
  getCoreRowModel,
  useReactTable,
} from "@tanstack/react-table";
import { useCallback, useMemo, useState, useTransition } from "react";
import { updateEndClientDefaultStopType } from "@/features/clients/actions/mutations/updateEndClientDefaultStopType";
import {
  Button,
  Checkbox,
  Strong,
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
  Text,
} from "@/features/shared/components";
import type { StopType } from "@/generated/prisma";

export type EndClientDefaultStopTypeRow = {
  id: string;
  name: string;
  address: string;
  defaultStopType: StopType | null;
  createdAt: Date;
};

const columnHelper = createColumnHelper<EndClientDefaultStopTypeRow>();

type EndClientDefaultStopTypeTableProps = {
  clientId: string;
  data: EndClientDefaultStopTypeRow[];
};

export function EndClientDefaultStopTypeTable({
  clientId,
  data,
}: EndClientDefaultStopTypeTableProps) {
  const [isPending, startTransition] = useTransition();

  // Force stable sorting on createdAt to prevent reordering
  const sortedData = useMemo(
    () => [...data].sort((a, b) => a.createdAt.getTime() - b.createdAt.getTime()),
    [data],
  );

  // Track pending changes: Map<endClientId, StopType | null>
  const [pendingChanges, setPendingChanges] = useState<
    Map<string, StopType | null>
  >(new Map());

  // Get the current stop type for an end client (from pending changes or original data)
  const getCurrentStopType = useCallback(
    (endClientId: string): StopType | null => {
      if (pendingChanges.has(endClientId)) {
        return pendingChanges.get(endClientId) ?? null;
      }
      return sortedData.find((row) => row.id === endClientId)?.defaultStopType ?? null;
    },
    [pendingChanges, sortedData],
  );

  const toggleStopType = useCallback(
    (endClientId: string, mode: "PICKUP" | "DROPOFF") => {
      const currentType = getCurrentStopType(endClientId);

      // Determine the new stop type based on current type and toggle mode
      const modes = new Set(
        currentType === "BOTH"
          ? ["PICKUP", "DROPOFF"]
          : currentType
            ? [currentType]
            : [],
      );

      // Toggle the mode
      modes.has(mode) ? modes.delete(mode) : modes.add(mode);

      // Calculate new type
      const newType: StopType | null =
        modes.size === 2
          ? "BOTH"
          : modes.size === 1
            ? ([...modes][0] as StopType)
            : null;

      // Update pending changes
      setPendingChanges((prev) => {
        const next = new Map(prev);
        next.set(endClientId, newType);
        return next;
      });
    },
    [getCurrentStopType],
  );

  const handleSubmit = () => {
    startTransition(async () => {
      // Submit all pending changes
      await Promise.all(
        Array.from(pendingChanges.entries()).map(([endClientId, defaultStopType]) =>
          updateEndClientDefaultStopType({
            endClientId,
            clientId,
            defaultStopType,
          }),
        ),
      );
      // Clear pending changes after successful submission
      setPendingChanges(new Map());
    });
  };

  const handleReset = () => {
    setPendingChanges(new Map());
  };

  const hasChanges = pendingChanges.size > 0;

  const columns = useMemo(
    () => [
      columnHelper.accessor("id", {
        header: "ID",
        enableSorting: false,
        enableColumnFilter: false,
        enableGlobalFilter: false,
        meta: { hidden: true },
      }),
      columnHelper.accessor("name", {
        header: () => <Text>Nom</Text>,
        cell: (props) => <Strong>{props.getValue()}</Strong>,
        enableSorting: false,
      }),
      ...(["PICKUP", "DROPOFF"] as const).map((typeMode) =>
        columnHelper.display({
          id: typeMode.toLowerCase(),
          header: () => (
            <Text>{typeMode === "PICKUP" ? "Collecte" : "Livraison"}</Text>
          ),
          cell: ({ row: { original } }) => {
            const currentStopType = getCurrentStopType(original.id);
            const isChecked = [typeMode, "BOTH"].includes(
              currentStopType ?? "",
            );
            return (
              <Checkbox
                checked={isChecked}
                disabled={isPending}
                onChange={() => toggleStopType(original.id, typeMode)}
              />
            );
          },
          enableSorting: false,
        }),
      ),
    ],
    [isPending, getCurrentStopType, toggleStopType],
  );

  const table = useReactTable<EndClientDefaultStopTypeRow>({
    data: sortedData,
    columns,
    getCoreRowModel: getCoreRowModel(),
    getRowId: (row) => row.id,
    enableSorting: false,
  });

  if (!sortedData.length) {
    return null;
  }

  const tableKey = sortedData.map((row) => row.id).join("-");

  return (
    <div className="space-y-4">
      <Table key={tableKey}>
        <TableHead>
          {table.getHeaderGroups().map((headerGroup) => (
            <TableRow key={headerGroup.id}>
              {headerGroup.headers
                // @ts-expect-error
                .filter((header) => !header.column.columnDef.meta?.hidden)
                .map((header) => (
                  <TableHeader key={header.id}>
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
              {row
                .getVisibleCells()
                // @ts-expect-error
                .filter((cell) => !cell.column.columnDef.meta?.hidden)
                .map((cell) => (
                  <TableCell key={cell.id}>
                    {flexRender(cell.column.columnDef.cell, cell.getContext())}
                  </TableCell>
                ))}
            </TableRow>
          ))}
        </TableBody>
      </Table>

      {hasChanges && (
        <div className="flex items-center gap-3">
          <Button
            type="button"
            onClick={handleSubmit}
            disabled={isPending}
          >
            Enregistrer les modifications
          </Button>
          <Button
            type="button"
            onClick={handleReset}
            disabled={isPending}
            outline
          >
            Annuler
          </Button>
        </div>
      )}
    </div>
  );
}
