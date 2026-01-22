"use client";

import { zodResolver } from "@hookform/resolvers/zod";
import {
  createColumnHelper,
  flexRender,
  getCoreRowModel,
  useReactTable,
} from "@tanstack/react-table";
import clsx from "clsx";
import { useMemo, useState, useTransition } from "react";
import { useForm } from "react-hook-form";
import UserEmpty from "@/assets/illustrations/user-empty.svg";
import { updateDelivery } from "@/features/deliveries/actions/mutations/updateDelivery";
import {
  type UpdateDeliveryFormInput,
  UpdateDeliveryFormSchema,
  type UpdateDeliveryStopFormInput,
} from "@/features/deliveries/schema/updateDelivery";
import type { DeliveryWithRelations } from "@/features/deliveries/types";
import {
  Button,
  Checkbox,
  EmptyState,
  ErrorMessage,
  Field,
  FieldGroup,
  Fieldset,
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
  Text,
  Textarea,
} from "@/features/shared/components";

type EditDeliveryFormProps = {
  delivery: DeliveryWithRelations<{
    deliveryCompany: true;
    driver: true;
    vehicle: true;
    stops: {
      include: {
        endClientCompany: {
          include: {
            address: true;
          };
        };
      };
    };
  }>;
};

const columnHelper = createColumnHelper<UpdateDeliveryStopFormInput>();

export function EditDeliveryStopsForm({ delivery }: EditDeliveryFormProps) {
  const [isPending, startTransition] = useTransition();
  const [error, setError] = useState<string | null>(null);

  const {
    watch,
    register,
    setValue,
    handleSubmit,
    formState: { errors },
  } = useForm<UpdateDeliveryFormInput>({
    resolver: zodResolver(UpdateDeliveryFormSchema),
    defaultValues: {
      notes: delivery.notes ?? "",
      stops: delivery.stops.map((stop) => ({
        companyId: stop.endClientCompany.id,
        name: stop.endClientCompany.name,
        sequence: stop.sequence ?? 0,
        type: stop.type,
        notes: stop.notes ?? "",
        selected: true,
      })),
    },
  });

  const onSubmit = async (input: UpdateDeliveryFormInput) => {
    startTransition(async () => {
      try {
        setError(null);
        await updateDelivery({
          deliveryId: delivery.id,
          input,
        });
      } catch (err) {
        setError(
          err instanceof Error ? err.message : "Failed to update delivery",
        );
      }
    });
  };

  const stops = watch("stops") ?? [];

  const getStopIndex = (companyId: string) =>
    stops.findIndex((s) => s.companyId === companyId);

  const toggleSelection = (companyId: string) => {
    const idx = getStopIndex(companyId);
    if (idx < 0) return;
    const isSelected = !stops[idx].selected;
    setValue(`stops.${idx}.selected`, isSelected);
    if (!isSelected) {
      setValue(`stops.${idx}.type`, null);
      setValue(`stops.${idx}.notes`, "");
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
              disabled={isPending}
              onChange={() => toggleSelection(original.companyId)}
            />
          );
        },
      }),
      columnHelper.accessor("name", {
        header: () => <Text>Client</Text>,
        footer: () => (
          <Text>{stops.filter((s) => s.selected).length} sélectionnés</Text>
        ),
        cell: (props) => <Strong>{props.getValue()}</Strong>,
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
          cell: ({ row: { original } }) => (
            <Checkbox
              checked={[mode, "BOTH"].includes(original.type ?? "")}
              disabled={!original.selected || isPending}
              onChange={() => toggleType(original.companyId, mode)}
            />
          ),
        }),
      ),
      columnHelper.accessor("notes", {
        header: () => <Text>Notes</Text>,
        cell: (props) => <Text>{props.getValue()}</Text>,
        enableSorting: false,
      }),
    ],
    [stops, isPending, getStopIndex, toggleSelection, toggleType],
  );

  const table = useReactTable({
    data: stops.sort((a, b) => a.name.localeCompare(b.name)),
    columns,
    getCoreRowModel: getCoreRowModel(),
  });

  return (
    <form onSubmit={handleSubmit(onSubmit)} className="space-y-8">
      {error && (
        <div className="rounded-lg bg-red-50 p-4 dark:bg-red-950/20">
          <ErrorMessage>{error}</ErrorMessage>
        </div>
      )}

      <Fieldset>
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
                    {headerGroup.headers.map((header, index, arr) => (
                      <TableHeader
                        key={header.id}
                        className={`${!index ? "pl-6!" : ""} ${index === arr.length - 1 ? "pr-6!" : ""}`}
                      >
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
                        className={`${!index ? "pl-6!" : ""} ${index === arr.length - 1 ? "pr-6!" : ""}`}
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

            {errors?.stops && (
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
              disabled={isPending}
            />
            {errors?.notes && (
              <ErrorMessage>{errors.notes.message}</ErrorMessage>
            )}
          </Field>
        </FieldGroup>
      </Fieldset>

      <div className="flex items-center justify-end gap-4">
        <Button type="submit" disabled={isPending}>
          {isPending ? "Sauvegarde en cours..." : "Sauvegarder"}
        </Button>
      </div>
    </form>
  );
}
