"use client";

import {
  createColumnHelper,
  flexRender,
  getCoreRowModel,
  useReactTable,
} from "@tanstack/react-table";
import clsx from "clsx";
import { CircleCheckIcon, ExternalLinkIcon } from "lucide-react";
import { useMemo } from "react";
import UserEmpty from "@/assets/illustrations/user-empty.svg";
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
import { StopStatusBadge } from "@/features/stops/components/StopStatusBadge";
import type { StopStatus, StopType } from "@/generated/prisma";
import { Time } from "@/lib/time";

export type DeliveryStopTableRow = {
  id: string;
  name: string;
  sequence: number;
  type: StopType;
  notes: string | null;
  status: StopStatus;
  driverNotes: string | null;
  imageUrl: string | null;
  completedAt: Date | null;
};

const columnHelper = createColumnHelper<DeliveryStopTableRow>();

type DeliveryStopTableProps = {
  data: DeliveryStopTableRow[];
};

export function DeliveryStopTable({ data }: DeliveryStopTableProps) {
  const hasDriverNotes = data.some(({ driverNotes }) => driverNotes);
  const hasImageUrl = data.some(({ imageUrl }) => imageUrl);

  const columns = useMemo(
    () => [
      columnHelper.accessor("name", {
        header: () => <Text>Client</Text>,
        cell: (props) => <Strong>{props.getValue()}</Strong>,
      }),
      ...(["PICKUP", "DROPOFF"] as const).map((mode) =>
        columnHelper.display({
          id: mode.toLowerCase(),
          header: () => (
            <Text>{mode === "PICKUP" ? "Collecte" : "Livraison"}</Text>
          ),
          cell: ({ row: { original } }) =>
            [mode, "BOTH"].includes(original.type) && (
              <CircleCheckIcon className="size-5 text-zinc-500 sm:text-sm/6 dark:text-zinc-400" />
            ),
        }),
      ),
      columnHelper.accessor("notes", {
        header: () => <Text>Notes</Text>,
        cell: (props) =>
          props.getValue() ? (
            <Text>{props.getValue()}</Text>
          ) : (
            <Text className="italic opacity-30">Pas de notes</Text>
          ),
      }),
      columnHelper.accessor("status", {
        header: () => <Text>Statut</Text>,
        cell: (props) => <StopStatusBadge status={props.getValue()} />,
      }),
      ...(hasDriverNotes
        ? [
            columnHelper.accessor("driverNotes", {
              header: () => <Text>Raison annulation</Text>,
              cell: (props) => {
                return props.getValue() ? (
                  <Text>{props.getValue()}</Text>
                ) : (
                  <Text className="italic opacity-30">Pas de notes</Text>
                );
              },
            }),
          ]
        : []),
      ...(hasImageUrl
        ? [
            columnHelper.accessor("imageUrl", {
              header: () => <Text>Photo</Text>,
              cell: (props) => {
                const url = props.getValue();
                if (!url) {
                  return <Text className="italic opacity-30">-</Text>;
                }

                return (
                  <a href={url} target="_blank" rel="noopener noreferrer">
                    <ExternalLinkIcon className="size-4 text-zinc-400 dark:text-zinc-500" />
                  </a>
                );
              },
            }),
          ]
        : []),
      columnHelper.accessor("completedAt", {
        header: () => <Text>Passage</Text>,
        cell: (props) =>
          props.getValue() ? (
            <Text>{Time(props.getValue()).format("LTS")}</Text>
          ) : (
            <Text className="italic opacity-30">-</Text>
          ),
      }),
    ],
    [hasDriverNotes, hasImageUrl],
  );

  const table = useReactTable<DeliveryStopTableRow>({
    data: [...data].sort((a, b) => a.sequence - b.sequence),
    columns,
    enableSorting: false,
    getCoreRowModel: getCoreRowModel(),
  });

  return (
    <Table
      dense
      striped
      className="rounded-2xl border border-zinc-950/10 dark:border-white/10"
    >
      <TableHead>
        {table.getHeaderGroups().map((headerGroup) => (
          <TableRow key={headerGroup.id}>
            {headerGroup.headers
              // @ts-expect-error
              .filter((header) => !header.column.columnDef.meta?.hidden)
              .map((header, index, arr) => {
                const canSort = header.column.getCanSort();
                const sortDirection = header.column.getIsSorted();

                return (
                  <TableHeader
                    key={header.id}
                    className={clsx(
                      header.column.getCanSort()
                        ? "cursor-pointer select-none hover:bg-zinc-50 dark:hover:bg-zinc-800"
                        : "",
                      !index && "pl-6!",
                      index === arr.length - 1 && "pr-6!",
                    )}
                    onClick={
                      canSort
                        ? header.column.getToggleSortingHandler()
                        : undefined
                    }
                  >
                    <div
                      className={clsx(
                        "flex items-center gap-2",
                        ["pickup", "dropoff"].includes(
                          header.column.columnDef.id ?? "",
                        ) && "justify-center!",
                      )}
                    >
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
                icon={UserEmpty}
                title="Vous n’avez pas encore de client"
                description="Ajoutez votre premier client pour démarrer !"
              />
            </TableCell>
          </TableRow>
        )}

        {table.getRowModel().rows.map((row) => (
          <TableRow key={row.id}>
            {row
              .getVisibleCells()
              // @ts-expect-error
              .filter((cell) => !cell.column.columnDef.meta?.hidden)
              .map((cell, index, arr) => (
                <TableCell
                  key={cell.id}
                  className={clsx(
                    !index && "pl-6!",
                    index === arr.length - 1 && "pr-6!",
                  )}
                >
                  <div
                    className={clsx(
                      "flex items-center",
                      ["pickup", "dropoff"].includes(
                        cell.column.columnDef.id ?? "",
                      ) && "justify-center!",
                    )}
                  >
                    {flexRender(cell.column.columnDef.cell, cell.getContext())}
                  </div>
                </TableCell>
              ))}
          </TableRow>
        ))}
      </TableBody>
    </Table>
  );
}
