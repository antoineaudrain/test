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
import clsx from "clsx";
import { endOfDay, isWithinInterval, startOfDay } from "date-fns";
import {
  CalendarCheck2Icon,
  CalendarClockIcon,
  HistoryIcon,
  XIcon,
} from "lucide-react";
import { useCallback, useMemo, useState } from "react";
import type { DateRange } from "react-day-picker";
import SearchEmpty from "@/assets/illustrations/search-empty.svg";
import TaskEmpty from "@/assets/illustrations/task-empty.svg";
import { DeliveryLabel } from "@/features/deliveries/components/DeliveryLabel";
import { StatusBadge } from "@/features/deliveries/components/StatusBadge";
import {
  DateRangePicker,
  EmptyState,
  Input,
  Select,
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
import { isFuture, isPast, isToday } from "@/features/shared/helper/time";
import type { DeliveryStatus } from "@/generated/prisma";
import { Time } from "@/lib/time";

export type DeliveryTableRow = {
  id: string;
  number: string | null;
  deliveryStatus?: DeliveryStatus;
  date: Date;
  driver: {
    firstName: string;
    lastName: string;
  } | null;
};

const columnHelper = createColumnHelper<DeliveryTableRow>();

type DeliveryTableProps = {
  data: DeliveryTableRow[];
  showDriverFilter?: boolean;
};

type FilterState = {
  status: string;
  dateRange: DateRange | undefined;
  driver: string;
};

export function DeliveryTable({
  data,
  showDriverFilter = true,
}: DeliveryTableProps) {
  const [sorting, setSorting] = useState<SortingState>([
    { id: "date", desc: true },
    { id: "number", desc: true },
  ]);
  const [globalFilter, setGlobalFilter] = useState<string>("");
  const [filters, setFilters] = useState<FilterState>({
    status: "all",
    dateRange: undefined,
    driver: "all",
  });

  const columns = useMemo(
    () => [
      columnHelper.accessor("number", {
        header: () => <Text>Tournée</Text>,
        cell: ({ row: { original } }) => (
          <div className="inline-flex items-center gap-4">
            {isPast(original.date) && (
              <HistoryIcon className="size-4 text-zinc-400" />
            )}
            {isToday(original.date) && (
              <CalendarCheck2Icon className="size-4 text-emerald-500" />
            )}
            {isFuture(original.date) && (
              <CalendarClockIcon className="size-4 text-blue-500" />
            )}
            <Strong>
              <DeliveryLabel number={original.number} date={original.date} />
            </Strong>
          </div>
        ),
        enableSorting: true,
        sortingFn: "alphanumeric",
      }),
      columnHelper.display({
        id: "status",
        header: () => <Text>Statut</Text>,
        cell: ({ row: { original } }) => (
          <StatusBadge deliveryStatus={original.deliveryStatus} />
        ),
      }),
      columnHelper.accessor("driver", {
        header: () => <Text>Chauffeur</Text>,
        cell: ({ getValue }) => {
          const driver = getValue();
          return driver ? (
            <Text>
              {driver.firstName} {driver.lastName}
            </Text>
          ) : (
            <Text className="text-zinc-400 dark:text-zinc-500">
              Non assigné
            </Text>
          );
        },
        enableSorting: true,
        sortingFn: (rowA, rowB) => {
          const driverA = rowA.original.driver;
          const driverB = rowB.original.driver;
          if (!driverA && !driverB) return 0;
          if (!driverA) return 1;
          if (!driverB) return -1;
          const nameA = `${driverA.firstName} ${driverA.lastName}`;
          const nameB = `${driverB.firstName} ${driverB.lastName}`;
          return nameA.localeCompare(nameB);
        },
      }),
      columnHelper.accessor("date", {
        header: () => <Text>Le</Text>,
        cell: (props) => <Text>{Time(props.getValue()).format("ll")}</Text>,
        enableSorting: true,
        sortingFn: "datetime",
      }),
    ],
    [],
  );

  const uniqueDrivers = useMemo(() => {
    const driverMap = new Map<
      string,
      { firstName: string; lastName: string }
    >();

    for (const delivery of data) {
      if (delivery.driver) {
        const driverId = `${delivery.driver.firstName} ${delivery.driver.lastName}`;
        if (!driverMap.has(driverId)) {
          driverMap.set(driverId, delivery.driver);
        }
      }
    }

    return Array.from(driverMap.values()).sort((a, b) =>
      `${a.firstName} ${a.lastName}`.localeCompare(
        `${b.firstName} ${b.lastName}`,
      ),
    );
  }, [data]);

  const filteredData = useMemo(() => {
    return data.filter((delivery) => {
      if (filters.status !== "all") {
        if (delivery.deliveryStatus !== filters.status) {
          return false;
        }
      }

      if (showDriverFilter && filters.driver !== "all") {
        if (filters.driver === "unassigned") {
          if (delivery.driver !== null) {
            return false;
          }
        } else {
          const driverFullName = delivery.driver
            ? `${delivery.driver.firstName} ${delivery.driver.lastName}`
            : null;
          if (driverFullName !== filters.driver) {
            return false;
          }
        }
      }

      if (filters.dateRange?.from) {
        const deliveryDate = delivery.date;
        const rangeStart = startOfDay(filters.dateRange.from);
        const rangeEnd = filters.dateRange.to
          ? endOfDay(filters.dateRange.to)
          : endOfDay(filters.dateRange.from);

        if (
          !isWithinInterval(deliveryDate, {
            start: rangeStart,
            end: rangeEnd,
          })
        ) {
          return false;
        }
      }

      return true;
    });
  }, [data, filters, showDriverFilter]);

  const table = useReactTable<DeliveryTableRow>({
    data: filteredData,
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

  const handleStatusFilterChange = useCallback((value: string) => {
    setFilters((prev) => ({ ...prev, status: value }));
  }, []);

  const handleDriverFilterChange = useCallback((value: string) => {
    setFilters((prev) => ({ ...prev, driver: value }));
  }, []);

  const handleDateRangeChange = useCallback((range: DateRange | undefined) => {
    setFilters((prev) => ({ ...prev, dateRange: range }));
  }, []);

  const handleResetFilters = useCallback(() => {
    setFilters({ status: "all", dateRange: undefined, driver: "all" });
    setGlobalFilter("");
  }, []);

  const hasActiveFilters =
    filters.status !== "all" ||
    (showDriverFilter && filters.driver !== "all") ||
    filters.dateRange !== undefined ||
    globalFilter !== "";

  return (
    <div className="space-y-6">
      <div className="space-y-4">
        {/* Search Input */}
        <div className="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
          <Input
            value={globalFilter}
            disabled={!data.length}
            onChange={(event) => handleSearchChange(event.target.value)}
            placeholder="Rechercher une livraison..."
            className="w-full sm:max-w-sm"
          />

          {hasActiveFilters && (
            <button
              type="button"
              onClick={handleResetFilters}
              className="inline-flex items-center justify-center gap-2 rounded-lg px-3 py-2 text-sm font-medium text-zinc-700 hover:bg-zinc-100 dark:text-zinc-300 dark:hover:bg-zinc-800 transition-colors"
            >
              <XIcon className="size-4" />
              Réinitialiser
            </button>
          )}
        </div>

        {/* Filters */}
        <div
          className={`grid grid-cols-1 gap-3 ${showDriverFilter ? "sm:grid-cols-2 lg:grid-cols-3" : "sm:grid-cols-2"}`}
        >
          <Select
            value={filters.status}
            onChange={(e) => handleStatusFilterChange(e.target.value)}
            disabled={!data.length}
          >
            <option value="all">Tous les statuts</option>
            <option value="PENDING">Demande en attente</option>
            <option value="DECLINED">Demande refusée</option>
            <option value="SCHEDULED">Livraison planifiée</option>
            <option value="IN_PROGRESS">En cours</option>
            <option value="COMPLETED">Terminée</option>
            <option value="CANCELLED">Annulée</option>
          </Select>

          {showDriverFilter && (
            <Select
              value={filters.driver}
              onChange={(e) => handleDriverFilterChange(e.target.value)}
              disabled={!data.length}
            >
              <option value="all">Tous les chauffeurs</option>
              <option value="unassigned">Non assigné</option>
              {uniqueDrivers.map((driver) => {
                const driverFullName = `${driver.firstName} ${driver.lastName}`;
                return (
                  <option key={driverFullName} value={driverFullName}>
                    {driverFullName}
                  </option>
                );
              })}
            </Select>
          )}

          <DateRangePicker
            value={filters.dateRange}
            onChange={handleDateRangeChange}
            disabled={!data.length}
            placeholder="Toutes les dates"
          />
        </div>
      </div>

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
                {hasActiveFilters && data.length ? (
                  <EmptyState
                    icon={SearchEmpty}
                    title="Aucune livraison ne correspond à votre recherche"
                    description="Modifiez votre recherche ou essayez un autre critère."
                  />
                ) : (
                  <EmptyState
                    icon={TaskEmpty}
                    title="Vous n'avez pas encore de livraison"
                    description="Ajoutez votre première livraison pour démarrer !"
                  />
                )}
              </TableCell>
            </TableRow>
          )}

          {table.getRowModel().rows.map((row) => (
            <TableRow
              key={row.id}
              href={`/deliveries/${row.original.id}`}
              className={clsx(!isToday(row.original.date) && "opacity-50")}
            >
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
