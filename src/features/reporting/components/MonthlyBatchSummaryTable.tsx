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

export type MonthlyBatchSummaryTableRow = {
  name: string;
  address: string;
  totalPickups: number;
  totalDropOffs: number;
  stopCount: number;
};

const columnHelper = createColumnHelper<MonthlyBatchSummaryTableRow>();

type MonthlyBatchSummaryTableProps = {
  data: MonthlyBatchSummaryTableRow[];
};

export function MonthlyBatchSummaryTable({
  data,
}: MonthlyBatchSummaryTableProps) {
  const [sorting, setSorting] = useState<SortingState>([
    { id: "name", desc: true },
  ]);

  const columns = useMemo(
    () => [
      columnHelper.accessor("name", {
        header: () => <Text>Client</Text>,
        cell: (props) => <Strong>{props.getValue()}</Strong>,
        enableSorting: true,
        sortingFn: "alphanumeric",
      }),
      columnHelper.accessor("address", {
        header: () => <Text>Adresse</Text>,
        cell: (props) => <Text>{props.getValue()}</Text>,
        enableSorting: true,
        sortingFn: "alphanumeric",
      }),
      columnHelper.accessor("totalDropOffs", {
        header: () => <Text>Total Collecte</Text>,
        cell: (props) => <Strong>{props.getValue()}</Strong>,
        enableSorting: true,
        sortingFn: "alphanumeric",
      }),
      columnHelper.accessor("totalPickups", {
        header: () => <Text>Total Livraison</Text>,
        cell: (props) => <Strong>{props.getValue()}</Strong>,
        enableSorting: true,
        sortingFn: "alphanumeric",
      }),
      columnHelper.accessor("stopCount", {
        header: () => <Text>Total Passage</Text>,
        cell: (props) => <Strong>{props.getValue()}</Strong>,
        enableSorting: true,
        sortingFn: "alphanumeric",
      }),
    ],
    [],
  );

  const table = useReactTable<MonthlyBatchSummaryTableRow>({
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
                  title="Vous n’avez pas encore de livraison"
                  description="Ajoutez votre première livraison pour démarrer !"
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
