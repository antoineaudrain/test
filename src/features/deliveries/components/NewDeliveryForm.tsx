"use client";

import { zodResolver } from "@hookform/resolvers/zod";
import {
  createColumnHelper,
  flexRender,
  getCoreRowModel,
  getSortedRowModel,
  type SortingState,
  useReactTable,
} from "@tanstack/react-table";
import clsx from "clsx";
import { useEffect, useMemo, useState } from "react";
import { useForm } from "react-hook-form";
import UserEmpty from "@/assets/illustrations/user-empty.svg";
import {
  type CreateDeliveryFormInput,
  type CreateDeliveryStopFormInput,
  createDeliveryFormSchemaWithExistingDates,
} from "@/features/deliveries/schema/createDelivery";
import {
  Button,
  Checkbox,
  EmptyState,
  ErrorMessage,
  Field,
  FieldGroup,
  Fieldset,
  Input,
  Label,
  Strong,
  Table,
  TableBody,
  TableCell,
  TableFoot,
  TableFooter,
  TableHead,
  TableHeader,
  TableRow,
  TableSortIndicator,
  Text,
  Textarea,
} from "@/features/shared/components";
import { Time, todayDateString } from "@/lib/time";

type EndClientData = {
  id: string;
  name: string;
  addressId: string;
  address: {
    formattedAddress: string;
  };
};

type NewDeliveryFormProps = {
  existingDeliveryDates: Date[];
  endClients: EndClientData[];
};

const columnHelper = createColumnHelper<CreateDeliveryStopFormInput>();

export function NewDeliveryForm({
  endClients,
  existingDeliveryDates,
}: NewDeliveryFormProps) {
  const [sorting, setSorting] = useState<SortingState>([]);
  const [_submitError, setSubmitError] = useState<string | null>(null);

  const {
    watch,
    trigger,
    register,
    setValue,
    handleSubmit,
    formState: { errors, isSubmitting },
  } = useForm<CreateDeliveryFormInput>({
    resolver: zodResolver(
      createDeliveryFormSchemaWithExistingDates(existingDeliveryDates),
    ),
    defaultValues: {
      stops: endClients.map((client, i) => ({
        companyId: client.id,
        selected: false,
        name: client.name,
        sequence: i,
        type: null,
        notes: undefined,
      })),
    },
  });

  const date = watch("date");
  const stops = watch("stops") ?? [];

  useEffect(() => {
    if (date) {
      trigger("date");
    }
  }, [date, trigger]);

  const getStopIndex = (companyId: string) =>
    stops.findIndex((s) => s.companyId === companyId);

  const toggleSelection = (companyId: string) => {
    const idx = getStopIndex(companyId);
    if (idx < 0) return;
    const isSelected = !stops[idx].selected;
    setValue(`stops.${idx}.selected`, isSelected);
    if (!isSelected) {
      setValue(`stops.${idx}.type`, null);
      setValue(`stops.${idx}.notes`, undefined);
    }
  };

  const toggleType = (companyId: string, mode: "PICKUP" | "DROPOFF") => {
    const idx = getStopIndex(companyId);
    if (idx < 0) return;
    const current = stops[idx].type;
    const modes = new Set(
      current === "BOTH" ? ["PICKUP", "DROPOFF"] : current ? [current] : [],
    );
    modes.has(mode) ? modes.delete(mode) : modes.add(mode);
    setValue(
      `stops.${idx}.type`,
      modes.size === 2
        ? "BOTH"
        : modes.size === 1
          ? ([...modes][0] as any)
          : null,
    );
  };

  const columns = useMemo(
    () => [
      columnHelper.accessor("selected", {
        header: () => <Text>Sélection</Text>,
        footer: () => <Text>Total: {stops.length}</Text>,
        cell: ({ row: { original } }) => {
          const stopIndex = getStopIndex(original.companyId);
          return (
            <Checkbox
              checked={stops[stopIndex].selected ?? false}
              disabled={isSubmitting}
              onChange={() => toggleSelection(original.companyId)}
            />
          );
        },
        enableSorting: false,
      }),
      columnHelper.accessor("name", {
        header: () => <Text>Client</Text>,
        footer: () => (
          <Text>{stops.filter((s) => s.selected).length} sélectionnés</Text>
        ),
        cell: (props) => <Strong>{props.getValue()}</Strong>,
        enableSorting: true,
        sortingFn: (a, b) => {
          return a.original.name.localeCompare(b.original.name, "fr", {
            numeric: true,
            sensitivity: "base",
          });
        },
      }),
      ...(["PICKUP", "DROPOFF"] as const).map((mode) =>
        columnHelper.display({
          id: mode.toLowerCase(),
          header: () => (
            <Text>{mode === "PICKUP" ? "Collecte" : "Livraison"}</Text>
          ),
          footer: () => (
            <Text>
              {
                stops.filter(
                  (s) => s.selected && [mode, "BOTH"].includes(s.type ?? ""),
                ).length
              }
            </Text>
          ),
          cell: ({ row: { original } }) => {
            const stopIndex = getStopIndex(original.companyId);
            const error = errors.stops?.[stopIndex]?.type?.message;

            return (
              <div className="flex flex-col gap-1">
                <div className={clsx("flex items-center gap-2 p-1 rounded")}>
                  <Checkbox
                    checked={[mode, "BOTH"].includes(original.type ?? "")}
                    disabled={!original.selected || isSubmitting}
                    onChange={() => toggleType(original.companyId, mode)}
                  />
                </div>
                {error && <ErrorMessage>{error}</ErrorMessage>}
              </div>
            );
          },
          enableSorting: false,
        }),
      ),
      columnHelper.accessor("notes", {
        header: () => <Text>Notes</Text>,
        cell: (props) => <Text>{props.getValue()}</Text>,
        enableSorting: false,
      }),
    ],
    [stops, isSubmitting, getStopIndex, toggleSelection, toggleType],
  );

  const table = useReactTable({
    data: stops.sort((a, b) => a.sequence - b.sequence),
    columns,
    state: { sorting },
    onSortingChange: setSorting,
    getCoreRowModel: getCoreRowModel(),
    getSortedRowModel: getSortedRowModel(),
  });

  const onSubmit = async (input: CreateDeliveryFormInput) => {
    try {
      setSubmitError(null);
      const res = await fetch("/api/deliveries", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(input),
      });

      const data = await res.json();

      if (!res.ok) {
        throw new Error(data.error || "Failed to new delivery");
      }

      window.location.href = `/deliveries/${data.id}`;
    } catch (err) {
      setSubmitError(err instanceof Error ? err.message : "An error occurred");
    }
  };

  return (
    <form onSubmit={handleSubmit(onSubmit)} className="space-y-8">
      <Fieldset>
        <FieldGroup>
          <Field>
            <Label>Date</Label>
            <Input type="date" {...register("date")} min={todayDateString()} />
            {errors?.date && <ErrorMessage>{errors.date.message}</ErrorMessage>}
          </Field>
        </FieldGroup>

        <FieldGroup>
          <Field className="flex flex-col gap-3">
            <Label>Clients</Label>
            {/* Desktop: Table layout */}
            <Table
              striped
              dense
              className="hidden sm:flex flex-col rounded-2xl border border-zinc-950/10 dark:border-white/10 overflow-hidden"
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
                        icon={UserEmpty}
                        title="Vous n’avez pas encore de client"
                        description="Ajoutez votre premier client pour démarrer !"
                      />
                    </TableCell>
                  </TableRow>
                )}

                {table.getRowModel().rows.map((row) => (
                  <TableRow key={row.id}>
                    {row.getVisibleCells().map((cell, index, arr) => {
                      return (
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
                      );
                    })}
                  </TableRow>
                ))}
              </TableBody>

              <TableFoot>
                {table.getFooterGroups().map((footerGroup) => (
                  <TableRow key={footerGroup.id}>
                    {footerGroup.headers.map((header, index, arr) => (
                      <TableFooter
                        key={header.id}
                        className={clsx(
                          !index && "pl-6!",
                          index === arr.length - 1 && "pr-6!",
                        )}
                      >
                        {flexRender(
                          header.column.columnDef.footer,
                          header.getContext(),
                        )}
                      </TableFooter>
                    ))}
                  </TableRow>
                ))}
              </TableFoot>
            </Table>

            {/* Mobile: Card layout */}
            <div className="sm:hidden space-y-3">
              {!stops.length && (
                <EmptyState
                  icon={UserEmpty}
                  title="Vous n'avez pas encore de client"
                  description="Ajoutez votre premier client pour démarrer !"
                />
              )}

              {stops.map((stop, _index) => {
                const stopIndex = getStopIndex(stop.companyId);
                const client = endClients.find((c) => c.id === stop.companyId);
                const error = errors.stops?.[stopIndex]?.type?.message;

                return (
                  <div
                    key={stop.companyId}
                    className={clsx(
                      "rounded-xl border-2 p-4 transition-all",
                      stops[stopIndex].selected
                        ? "border-blue-300 dark:border-blue-700 bg-blue-50/50 dark:bg-blue-950/20"
                        : "border-zinc-200 dark:border-zinc-700",
                    )}
                  >
                    {/* Selection checkbox + client name */}
                    <div className="flex items-start gap-3 mb-3">
                      <button
                        type="button"
                        onClick={() => toggleSelection(stop.companyId)}
                        disabled={isSubmitting}
                        className="p-2 -m-2 rounded-lg touch-manipulation"
                        aria-label={
                          stops[stopIndex].selected
                            ? `Désélectionner ${stop.name}`
                            : `Sélectionner ${stop.name}`
                        }
                      >
                        <Checkbox
                          checked={stops[stopIndex].selected ?? false}
                          disabled={isSubmitting}
                          onChange={() => {}} // Handled by parent button
                        />
                      </button>
                      <div className="flex-1 min-w-0">
                        <Strong className="block">{stop.name}</Strong>
                        {client && (
                          <Text className="text-sm text-zinc-600 dark:text-zinc-400 mt-1 line-clamp-2">
                            {client.address.formattedAddress}
                          </Text>
                        )}
                      </div>
                    </div>

                    {/* Pickup/Dropoff buttons - only when selected */}
                    {stops[stopIndex].selected && (
                      <div className="flex gap-3 pt-3 border-t border-zinc-200 dark:border-zinc-700">
                        {/* Collecte (Pickup) button */}
                        <button
                          type="button"
                          onClick={() => toggleType(stop.companyId, "PICKUP")}
                          disabled={isSubmitting}
                          className={clsx(
                            "flex-1 flex items-center justify-center gap-2 py-3 px-4 rounded-lg",
                            "font-medium text-sm transition-all touch-manipulation",
                            ["PICKUP", "BOTH"].includes(
                              stops[stopIndex].type ?? "",
                            )
                              ? "bg-green-100 dark:bg-green-900/30 text-green-700 dark:text-green-300 border-2 border-green-300 dark:border-green-700"
                              : "bg-zinc-100 dark:bg-zinc-800 text-zinc-600 dark:text-zinc-400 border-2 border-transparent",
                          )}
                        >
                          <Checkbox
                            checked={["PICKUP", "BOTH"].includes(
                              stops[stopIndex].type ?? "",
                            )}
                            disabled={isSubmitting}
                            onChange={() => {}}
                          />
                          Collecte
                        </button>

                        {/* Livraison (Dropoff) button */}
                        <button
                          type="button"
                          onClick={() => toggleType(stop.companyId, "DROPOFF")}
                          disabled={isSubmitting}
                          className={clsx(
                            "flex-1 flex items-center justify-center gap-2 py-3 px-4 rounded-lg",
                            "font-medium text-sm transition-all touch-manipulation",
                            ["DROPOFF", "BOTH"].includes(
                              stops[stopIndex].type ?? "",
                            )
                              ? "bg-blue-100 dark:bg-blue-900/30 text-blue-700 dark:text-blue-300 border-2 border-blue-300 dark:border-blue-700"
                              : "bg-zinc-100 dark:bg-zinc-800 text-zinc-600 dark:text-zinc-400 border-2 border-transparent",
                          )}
                        >
                          <Checkbox
                            checked={["DROPOFF", "BOTH"].includes(
                              stops[stopIndex].type ?? "",
                            )}
                            disabled={isSubmitting}
                            onChange={() => {}}
                          />
                          Livraison
                        </button>
                      </div>
                    )}

                    {/* Error message */}
                    {error && (
                      <div className="mt-2">
                        <ErrorMessage>{error}</ErrorMessage>
                      </div>
                    )}
                  </div>
                );
              })}
            </div>

            {errors?.stops?.message && (
              <ErrorMessage>{errors.stops.message}</ErrorMessage>
            )}
          </Field>
        </FieldGroup>

        <FieldGroup>
          <Field>
            <Label>Notes</Label>
            <Textarea
              {...register("notes")}
              rows={4}
              placeholder="Détaillez les contraintes horaires, accès spécifiques ou infos utiles pour la livraison..."
              disabled={isSubmitting}
            />
            {errors?.notes && (
              <ErrorMessage>{errors.notes.message}</ErrorMessage>
            )}
          </Field>
        </FieldGroup>
      </Fieldset>

      <div className="sticky bottom-0 left-0 right-0 bg-white dark:bg-zinc-900 border-t border-zinc-200 dark:border-zinc-700 -mx-6 px-6 py-4 mt-8 sm:static sm:border-0 sm:mx-0 sm:px-0 sm:py-0 sm:mt-8 sm:bg-transparent">
        <div className="flex flex-col-reverse sm:flex-row sm:items-center sm:justify-end gap-3">
          <Button
            type="submit"
            disabled={isSubmitting}
            className="w-full sm:w-auto"
          >
            {isSubmitting ? "Création en cours..." : "Créer"}
          </Button>
        </div>
      </div>
    </form>
  );
}
