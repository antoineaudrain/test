"use client";

import {
  createColumnHelper,
  flexRender,
  getCoreRowModel,
  getSortedRowModel,
  type SortingState,
  useReactTable,
} from "@tanstack/react-table";
import { useMemo, useState } from "react";
import TaskEmpty from "@/assets/illustrations/task-empty.svg";
import {
  EmptyState,
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

export type ClientDeliverySummaryTableRow = {
  endClientId: string;
  endClientName: string;
  endClientAddress: string;
  totalPickups: number;
  totalDropoffs: number;
  totalStops: number;
};

const columnHelper = createColumnHelper<ClientDeliverySummaryTableRow>();

type ClientDeliverySummaryTableProps = {
  data: ClientDeliverySummaryTableRow[];
};

export function ClientDeliverySummaryTable({
  data,
}: ClientDeliverySummaryTableProps) {
  const [sorting, setSorting] = useState<SortingState>([
    { id: "endClientName", desc: false },
  ]);

  const columns = useMemo(
    () => [
      columnHelper.accessor("endClientName", {
        header: () => <Text>Client Final</Text>,
        cell: (props) => <Strong>{props.getValue()}</Strong>,
        enableSorting: true,
        sortingFn: "alphanumeric",
      }),
      columnHelper.accessor("endClientAddress", {
        header: () => <Text>Adresse</Text>,
        cell: (props) => <Text>{props.getValue()}</Text>,
        enableSorting: true,
        sortingFn: "alphanumeric",
      }),
      columnHelper.accessor("totalPickups", {
        header: () => <Text>Total Collectes</Text>,
        cell: (props) => <Strong>{props.getValue()}</Strong>,
        enableSorting: true,
        sortingFn: "alphanumeric",
      }),
      columnHelper.accessor("totalDropoffs", {
        header: () => <Text>Total Livraisons</Text>,
        cell: (props) => <Strong>{props.getValue()}</Strong>,
        enableSorting: true,
        sortingFn: "alphanumeric",
      }),
      columnHelper.accessor("totalStops", {
        header: () => <Text>Total Passages</Text>,
        cell: (props) => <Strong>{props.getValue()}</Strong>,
        enableSorting: true,
        sortingFn: "alphanumeric",
      }),
    ],
    [],
  );

  const table = useReactTable<ClientDeliverySummaryTableRow>({
    data,
    columns,
    state: { sorting },
    onSortingChange: setSorting,
    getCoreRowModel: getCoreRowModel(),
    getSortedRowModel: getSortedRowModel(),
  });

  return (
    <div className="space-y-6">
      <Table striped>
        <TableHead>
          {table.getHeaderGroups().map((headerGroup) => (
            <TableRow key={headerGroup.id}>
              {headerGroup.headers.map((header) => {
                const canSort = header.column.getCanSort();
                const sortDirection = header.column.getIsSorted();

                return (
                  <TableHeader
                    key={header.id}
                    className={
                      header.column.getCanSort()
                        ? "cursor-pointer select-none hover:bg-zinc-50 dark:hover:bg-zinc-800"
                        : ""
                    }
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
                <EmptyState
                  icon={TaskEmpty}
                  title="Aucune livraison complétée"
                  description="Aucune livraison n'a été complétée dans cette période."
                />
              </TableCell>
            </TableRow>
          )}

          {table.getRowModel().rows.map((row) => (
            <TableRow key={row.id}>
              {row.getVisibleCells().map((cell) => (
                <TableCell key={cell.id}>
                  {flexRender(cell.column.columnDef.cell, cell.getContext())}
                </TableCell>
              ))}
            </TableRow>
          ))}
        </TableBody>
      </Table>
    </div>
  );
}
