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
import { CircleCheckIcon } from "lucide-react";
import { useRouter } from "next/navigation";
import { useMemo, useState } from "react";
import {
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

export type DeliveryRequestTableRow = {
  id: string;
  date: string;
  clientCompanyName: string;
  endClients: Array<{
    name: string;
    hasPickup: boolean;
    hasDropoff: boolean;
  }>;
  notes: string | null;
};

type DeliveryRequestTableProps = {
  data: DeliveryRequestTableRow[];
};

const columnHelper = createColumnHelper<DeliveryRequestTableRow>();

export function DeliveryRequestTable({ data }: DeliveryRequestTableProps) {
  const router = useRouter();
  const [sorting, setSorting] = useState<SortingState>([
    { id: "clientCompanyName", desc: false },
  ]);

  const columns = useMemo(
    () => [
      columnHelper.accessor("clientCompanyName", {
        header: () => <Text>Client</Text>,
        cell: (info) => <Strong>{info.getValue()}</Strong>,
        enableSorting: true,
        sortingFn: (a, b) => {
          return a.original.clientCompanyName.localeCompare(
            b.original.clientCompanyName,
            "fr",
            {
              numeric: true,
              sensitivity: "base",
            },
          );
        },
      }),
      columnHelper.accessor("endClients", {
        header: () => <Text>Arrêts</Text>,
        cell: (info) => {
          const endClients = info.getValue();
          if (!endClients.length) return <Text className="italic opacity-30">Aucun arrêt</Text>;
          const count = endClients.length;
          return <Text>{count} client{count > 1 ? "s" : ""}</Text>;
        },
      }),
      columnHelper.accessor("notes", {
        header: () => <Text>Notes</Text>,
        cell: (info) => {
          const notes = info.getValue();
          if (!notes) return <Text className="italic opacity-30">Pas de notes</Text>;
          return (
            <Text className="line-clamp-2" title={notes}>
              {notes}
            </Text>
          );
        },
      }),
    ],
    [],
  );

  const table = useReactTable({
    data,
    columns,
    state: { sorting },
    onSortingChange: setSorting,
    getCoreRowModel: getCoreRowModel(),
    getSortedRowModel: getSortedRowModel(),
  });

  if (data.length === 0) {
    return (
      <div className="text-center py-8 text-zinc-500">
        Aucune demande de livraison pour aujourd'hui
      </div>
    );
  }

  return (
    <Table
      dense
      striped
      className="rounded-2xl border border-zinc-950/10 dark:border-white/10"
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
                    canSort ? header.column.getToggleSortingHandler() : undefined
                  }
                >
                  <div className="flex items-center gap-2">
                    {flexRender(
                      header.column.columnDef.header,
                      header.getContext(),
                    )}
                    {canSort && (
                      <TableSortIndicator sortDirection={sortDirection || undefined} />
                    )}
                  </div>
                </TableHeader>
              );
            })}
          </TableRow>
        ))}
      </TableHead>
      <TableBody>
        {table.getRowModel().rows.map((row) => (
          <TableRow
            key={row.id}
            onClick={() => router.push(`/delivery-requests/${row.original.id}`)}
            className={clsx(
              "cursor-pointer hover:bg-zinc-100 dark:hover:bg-zinc-700",
            )}
          >
            {row.getVisibleCells().map((cell, index, arr) => (
              <TableCell
                key={cell.id}
                className={clsx(
                  !index && "pl-6!",
                  index === arr.length - 1 && "pr-6!",
                )}
              >
                {flexRender(cell.column.columnDef.cell, cell.getContext())}
              </TableCell>
            ))}
          </TableRow>
        ))}
      </TableBody>
    </Table>
  );
}
