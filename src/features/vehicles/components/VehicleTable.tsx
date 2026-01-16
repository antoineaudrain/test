"use client";

import {
  createColumnHelper,
  flexRender,
  getCoreRowModel,
  getFilteredRowModel,
  getSortedRowModel,
  type SortingState,
  useReactTable,
} from "@tanstack/react-table";
import { useCallback, useMemo, useState } from "react";

import SearchEmpty from "@/assets/illustrations/search-empty.svg";
import {
  EmptyState,
  Input,
  Strong,
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
  TableSortIndicator,
  Text,
  TextLink,
} from "@/features/shared/components";
import { Time } from "@/lib/time";

export type VehicleTableRow = {
  id: string;
  model: string | null;
  plate: string;
  driverId: string | null;
  driverName: string | null;
  createdAt: Date;
};

const columnHelper = createColumnHelper<VehicleTableRow>();

type ClientsTableProps = {
  data: VehicleTableRow[];
};

export function VehicleTable({ data }: ClientsTableProps) {
  const [sorting, setSorting] = useState<SortingState>([
    { id: "createdAt", desc: true },
  ]);
  const [globalFilter, setGlobalFilter] = useState<string>("");

  const columns = useMemo(
    () => [
      columnHelper.accessor("id", {
        header: "ID",
        enableSorting: false,
        enableColumnFilter: false,
        enableGlobalFilter: false,
        meta: { hidden: true },
      }),
      columnHelper.accessor("model", {
        header: () => <Text>Modèle</Text>,
        cell: (props) =>
          props.getValue() ? (
            <Strong>{props.getValue()}</Strong>
          ) : (
            <Text>-</Text>
          ),
        enableSorting: false,
      }),
      columnHelper.accessor("plate", {
        header: () => <Text>Numéro de plaque</Text>,
        cell: (props) => <Strong>{props.getValue()}</Strong>,
        enableSorting: false,
      }),
      columnHelper.accessor("driverName", {
        header: () => <Text>Conducteur</Text>,
        cell: (props) => {
          const { driverId } = props.row.original;
          return driverId ? (
            <TextLink href={`/employees/${props.row.original.driverId}`}>
              {props.getValue() ?? "-"}
            </TextLink>
          ) : (
            <Text>-</Text>
          );
        },
        enableSorting: false,
      }),
      columnHelper.accessor("createdAt", {
        header: () => <Text>Ajouté le</Text>,
        cell: (props) => <Text>{Time(props.getValue()).format("ll")}</Text>,
        enableSorting: true,
        sortingFn: "datetime",
      }),
    ],
    [],
  );

  const table = useReactTable<VehicleTableRow>({
    data,
    columns,
    state: {
      sorting,
      globalFilter,
    },
    onSortingChange: setSorting,
    onGlobalFilterChange: setGlobalFilter,
    getCoreRowModel: getCoreRowModel(),
    getSortedRowModel: getSortedRowModel(),
    getFilteredRowModel: getFilteredRowModel(),
  });

  const handleSearchChange = useCallback(
    (value: string) => {
      setGlobalFilter(value);
      table.setPageIndex(0);
    },
    [table],
  );

  return (
    <div className="space-y-6">
      <Input
        value={globalFilter}
        disabled={!data.length}
        onChange={(event) => handleSearchChange(event.target.value)}
        placeholder="Rechercher un vehicule..."
        className="max-w-sm"
      />

      <Table striped>
        <TableHead>
          {table.getHeaderGroups().map((headerGroup) => (
            <TableRow key={headerGroup.id}>
              {headerGroup.headers
                // @ts-expect-error
                .filter((header) => !header.column.columnDef.meta?.hidden)
                .map((header) => {
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
                {globalFilter && data.length ? (
                  <EmptyState
                    icon={SearchEmpty}
                    title="Aucun véhicule ne correspond à votre recherche"
                    description="Modifiez votre recherche ou essayez un autre critère."
                  />
                ) : (
                  <EmptyState
                    icon={SearchEmpty}
                    title="Vous n’avez pas encore de véhicules"
                    description="Ajoutez votre véhicule client pour démarrer !"
                  />
                )}
              </TableCell>
            </TableRow>
          )}

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
    </div>
  );
}
