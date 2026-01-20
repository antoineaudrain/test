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
import { AlertCircleIcon } from "lucide-react";
import { useEffect, useMemo, useState, useTransition } from "react";
import { useForm } from "react-hook-form";
import { z } from "zod";
import UserEmpty from "@/assets/illustrations/user-empty.svg";
import { cancelDeliveryRequest } from "@/features/delivery-requests/actions/mutations/cancelDeliveryRequest";
import { createDeliveryRequest } from "@/features/delivery-requests/actions/mutations/createDeliveryRequest";
import { updateDeliveryRequest } from "@/features/delivery-requests/actions/mutations/updateDeliveryRequest";
import { canModifyRequest } from "@/features/delivery-requests/actions/queries/canModifyRequest";
import type { DeliveryRequestWithStops } from "@/features/delivery-requests/types";
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
import { isPast } from "@/features/shared/helper/time";
import { Time } from "@/lib/time";

type EndClientData = {
  id: string;
  name: string;
  addressId: string;
  address: {
    formattedAddress: string;
  };
};

type NewDeliveryRequestFormProps = {
  mode: "create" | "edit";
  existingDeliveryRequestDates?: Date[];
  endClients: EndClientData[];
  request?: DeliveryRequestWithStops;
};

// Form schema (similar to CreateDeliveryFormSchema)
const CreateDeliveryRequestStopFormSchema = z
  .object({
    id: z.string().optional(), // For edit mode
    companyId: z.string(),
    selected: z.boolean(),
    name: z.string(),
    sequence: z.number().int().nonnegative(),
    type: z.enum(["PICKUP", "DROPOFF", "BOTH"]).nullable(),
    notes: z.string().optional(),
    hasDelivery: z.boolean().optional(), // Track if stop is linked to delivery
  })
  .refine((stop) => !(stop.selected && stop.type === null), {
    message: "Le type requis",
    path: ["type"],
  });

type CreateDeliveryRequestStopFormInput = z.infer<
  typeof CreateDeliveryRequestStopFormSchema
>;

const CreateDeliveryRequestFormSchema = z.object({
  date: z.string().nonempty("La date est requise"),
  notes: z.string().optional(),
  stops: z
    .array(CreateDeliveryRequestStopFormSchema)
    .min(1, "Au moins un arrêt doit être sélectionné")
    .refine((stops) => stops.some((stop) => stop.selected), {
      message: "Au moins un arrêt doit être sélectionné",
    }),
});

type CreateDeliveryRequestFormInput = z.infer<
  typeof CreateDeliveryRequestFormSchema
>;

const createDeliveryRequestFormSchemaWithExistingDates = (
  existingDates: Date[],
  currentDate?: string,
) =>
  CreateDeliveryRequestFormSchema.superRefine((data, ctx) => {
    if (isPast(data.date)) {
      ctx.addIssue({
        path: ["date"],
        code: z.ZodIssueCode.custom,
        message: "La date ne peut pas être dans le passé",
      });
    }

    const formattedExisting = existingDates.map((d) =>
      Time(d).format("YYYY-MM-DD"),
    );

    // Only check for duplicates if we're not editing the current date
    if (
      data.date !== currentDate &&
      formattedExisting.includes(Time(data.date).format("YYYY-MM-DD"))
    ) {
      ctx.addIssue({
        path: ["date"],
        code: z.ZodIssueCode.custom,
        message: "Une demande de livraison existe déjà pour cette date",
      });
    }
  });

const columnHelper = createColumnHelper<CreateDeliveryRequestStopFormInput>();

export function NewDeliveryRequestForm({
  mode,
  endClients,
  existingDeliveryRequestDates = [],
  request,
}: NewDeliveryRequestFormProps) {
  const [sorting, setSorting] = useState<SortingState>([]);
  const [submitError, setSubmitError] = useState<string | null>(null);
  const [isPending, startTransition] = useTransition();
  const [canModify, setCanModify] = useState(true);
  const [timeRemaining, setTimeRemaining] = useState<number | null>(null);
  const [cutoffTime, setCutoffTime] = useState<string | null>(null);

  const currentDate =
    mode === "edit" && request
      ? Time(request.date).format("YYYY-MM-DD")
      : undefined;

  // Create initial stops based on mode
  const getInitialStops = () => {
    if (mode === "edit" && request) {
      // In edit mode, map existing stops to form format
      return endClients.map((client, i) => {
        const existingStop = request.stops.find(
          (s) => s.endClientId === client.id,
        );
        return {
          id: existingStop?.id,
          companyId: client.id,
          selected: !!existingStop,
          name: client.name,
          sequence: existingStop?.sequence ?? i,
          type: existingStop?.type ?? null,
          notes: existingStop?.notes ?? undefined,
          hasDelivery: !!existingStop?.deliveryStop,
        };
      });
    } else {
      // In new mode, all unselected
      return endClients.map((client, i) => ({
        companyId: client.id,
        selected: false,
        name: client.name,
        sequence: i,
        type: null,
        notes: undefined,
        hasDelivery: false,
      }));
    }
  };

  const {
    watch,
    trigger,
    register,
    setValue,
    handleSubmit,
    formState: { errors, isSubmitting },
  } = useForm<CreateDeliveryRequestFormInput>({
    resolver: zodResolver(
      createDeliveryRequestFormSchemaWithExistingDates(
        existingDeliveryRequestDates,
        currentDate,
      ),
    ),
    defaultValues: {
      date:
        mode === "edit" && request
          ? Time(request.date).format("YYYY-MM-DD")
          : "",
      notes: mode === "edit" && request ? (request.notes ?? "") : "",
      stops: getInitialStops(),
    },
  });

  const date = watch("date");
  const stops = watch("stops") ?? [];

  // Check cutoff time for edit mode
  useEffect(() => {
    if (mode === "edit" && request && date) {
      canModifyRequest({
        clientCompanyId: request.clientCompanyId,
        requestDate: date,
      })
        .then((result) => {
          setCanModify(result.canModify);
          setTimeRemaining(result.timeRemaining ?? null);
          setCutoffTime(result.cutoffTime ?? null);
        })
        .catch(console.error);
    }
  }, [mode, request, date]);

  // Update timer
  useEffect(() => {
    if (timeRemaining !== null && timeRemaining > 0) {
      const interval = setInterval(() => {
        setTimeRemaining((prev) => (prev !== null && prev > 0 ? prev - 1 : 0));
      }, 1000);
      return () => clearInterval(interval);
    }
  }, [timeRemaining]);

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

    // Prevent deselecting stops that are linked to deliveries
    if (mode === "edit" && stops[idx].hasDelivery && stops[idx].selected) {
      return;
    }

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
          const isDisabled =
            isSubmitting ||
            isPending ||
            !canModify ||
            (mode === "edit" && original.hasDelivery && original.selected);
          return (
            <Checkbox
              checked={stops[stopIndex].selected ?? false}
              disabled={isDisabled}
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
                    disabled={
                      !original.selected ||
                      isSubmitting ||
                      isPending ||
                      original.hasDelivery
                    }
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
    [
      stops,
      isSubmitting,
      isPending,
      canModify,
      mode,
      getStopIndex,
      toggleSelection,
      toggleType,
    ],
  );

  const table = useReactTable({
    data: stops.sort((a, b) => a.sequence - b.sequence),
    columns,
    state: { sorting },
    onSortingChange: setSorting,
    getCoreRowModel: getCoreRowModel(),
    getSortedRowModel: getSortedRowModel(),
  });

  const onSubmit = async (input: CreateDeliveryRequestFormInput) => {
    try {
      console.log("Form submitted with input:", input);
      setSubmitError(null);

      // Transform form data to match CreateDeliveryRequestInput/UpdateDeliveryRequestInput schema
      const selectedStops = input.stops
        .filter((stop) => stop.selected && stop.type)
        .map((stop, index) => {
          const endClient = endClients.find((ec) => ec.id === stop.companyId);
          if (!endClient) {
            throw new Error(`End client not found: ${stop.companyId}`);
          }
          return {
            id: stop.id, // Include ID for updates
            sequence: index + 1,
            type: stop.type as "PICKUP" | "DROPOFF" | "BOTH",
            endClientId: stop.companyId,
            addressId: endClient.addressId,
            notes: stop.notes,
          };
        });

      console.log("Selected stops:", selectedStops);

      if (selectedStops.length === 0) {
        setSubmitError("Au moins un arrêt doit être sélectionné");
        return;
      }

      startTransition(async () => {
        try {
          console.log("Starting transition, mode:", mode);
          if (mode === "create") {
            console.log("Calling createDeliveryRequest");
            await createDeliveryRequest({
              input: {
                date: input.date,
                notes: input.notes,
                stops: selectedStops,
              },
            });
            console.log("createDeliveryRequest completed");
          } else if (mode === "edit" && request) {
            console.log("Calling updateDeliveryRequest");
            await updateDeliveryRequest({
              input: {
                requestId: request.id,
                notes: input.notes,
                stops: selectedStops,
              },
            });
            console.log("updateDeliveryRequest completed");
          }
        } catch (err) {
          console.error("Error in transition:", err);
          setSubmitError(
            err instanceof Error ? err.message : "Une erreur est survenue",
          );
        }
      });
    } catch (err) {
      console.error("Error in onSubmit:", err);
      setSubmitError(
        err instanceof Error ? err.message : "Une erreur est survenue",
      );
    }
  };

  const handleCancel = async () => {
    if (
      !request ||
      !confirm("Êtes-vous sûr de vouloir annuler cette demande ?")
    ) {
      return;
    }

    startTransition(async () => {
      try {
        await cancelDeliveryRequest({ input: { requestId: request.id } });
      } catch (error) {
        setSubmitError(
          error instanceof Error ? error.message : "Une erreur est survenue",
        );
      }
    });
  };

  const _formatTimeRemaining = (seconds: number) => {
    const hours = Math.floor(seconds / 3600);
    const minutes = Math.floor((seconds % 3600) / 60);
    return `${hours}h ${minutes}m`;
  };

  const hasAssignedDeliveries =
    mode === "edit" && request?.stops.some((s) => s.deliveryStopId !== null);

  return (
    <form onSubmit={handleSubmit(onSubmit)} className="space-y-8">
      {submitError && (
        <div className="bg-red-50 dark:bg-red-950/20 border border-red-200 dark:border-red-800 rounded-lg p-4">
          <p className="text-red-900 dark:text-red-100">{submitError}</p>
        </div>
      )}

      {/* Cutoff Warning */}
      {mode === "edit" && !canModify && cutoffTime && (
        <div className="bg-red-50 dark:bg-red-950/20 border border-red-200 dark:border-red-800 rounded-lg p-4">
          <div className="flex items-start gap-3">
            <AlertCircleIcon className="h-5 w-5 text-red-600 dark:text-red-400 flex-shrink-0 mt-0.5" />
            <div>
              <p className="font-medium text-red-900 dark:text-red-100">
                Heure limite dépassée
              </p>
              <p className="text-sm text-red-700 dark:text-red-300 mt-1">
                L'heure limite de modification ({cutoffTime}) est dépassée. Vous
                ne pouvez plus modifier cette demande.
              </p>
            </div>
          </div>
        </div>
      )}

      {/* Assigned Deliveries Warning */}
      {hasAssignedDeliveries && (
        <div className="bg-amber-50 dark:bg-amber-950/20 border border-amber-200 dark:border-amber-800 rounded-lg p-4">
          <div className="flex items-start gap-3">
            <AlertCircleIcon className="h-5 w-5 text-amber-600 dark:text-amber-400 flex-shrink-0 mt-0.5" />
            <div>
              <p className="font-medium text-amber-900 dark:text-amber-100">
                Demande utilisée pour créer des livraisons
              </p>
              <p className="text-sm text-amber-700 dark:text-amber-300 mt-1">
                Cette demande a été utilisée pour créer des livraisons. Vous pouvez
                ajouter de nouveaux arrêts, mais vous ne pouvez pas supprimer les
                arrêts existants qui sont liés à des livraisons.
              </p>
            </div>
          </div>
        </div>
      )}

      <Fieldset>
        <FieldGroup>
          <Field>
            <Label>Date</Label>
            <Input
              type="date"
              {...register("date")}
              min={Time().format("YYYY-MM-DD")}
              disabled={mode === "edit" || !canModify}
            />
            {errors?.date && <ErrorMessage>{errors.date.message}</ErrorMessage>}
          </Field>
        </FieldGroup>

        <FieldGroup>
          <Field className="flex flex-col gap-3">
            <Label>Clients</Label>
            <Table
              striped
              dense
              className="flex flex-col rounded-2xl border border-zinc-950/10 dark:border-white/10 overflow-hidden"
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
                        title="Vous n'avez pas encore de client"
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
              disabled={isSubmitting || isPending}
            />
            {errors?.notes && (
              <ErrorMessage>{errors.notes.message}</ErrorMessage>
            )}
          </Field>
        </FieldGroup>
      </Fieldset>

      <div className="flex items-center justify-end gap-4">
        {mode === "edit" && (
          <Button
            type="button"
            onClick={handleCancel}
            className="bg-red-600 hover:bg-red-700 text-white"
            disabled={isPending || !canModify}
          >
            Annuler la demande
          </Button>
        )}
        <Button
          type="submit"
          disabled={
            isSubmitting || isPending || (mode === "edit" && !canModify)
          }
        >
          {isSubmitting || isPending
            ? mode === "create"
              ? "Création en cours..."
              : "Mise à jour en cours..."
            : mode === "create"
              ? "Créer"
              : "Sauvegarder"}
        </Button>
      </div>
    </form>
  );
}
