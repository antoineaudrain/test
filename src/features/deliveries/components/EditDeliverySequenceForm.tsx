"use client";

import {
  closestCenter,
  DndContext,
  type DragEndEvent,
  KeyboardSensor,
  PointerSensor,
  useSensor,
  useSensors,
} from "@dnd-kit/core";
import { restrictToVerticalAxis } from "@dnd-kit/modifiers";
import {
  arrayMove,
  SortableContext,
  sortableKeyboardCoordinates,
  useSortable,
  verticalListSortingStrategy,
} from "@dnd-kit/sortable";
import { CSS } from "@dnd-kit/utilities";
import {
  type ColumnDef,
  createColumnHelper,
  flexRender,
  getCoreRowModel,
  type Row,
  useReactTable,
} from "@tanstack/react-table";
import clsx from "clsx";
import { CircleCheckIcon, GripVertical, Loader2Icon } from "lucide-react";
import { useMemo, useState } from "react";
import UserEmpty from "@/assets/illustrations/user-empty.svg";
import type { DeliveryWithRelations } from "@/features/deliveries/types";
import {
  EmptyState,
  Strong,
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
  Text,
} from "@/features/shared/components";
import { updateSequences } from "@/features/stops/actions/mutations/updateSequences";
import type { StopType } from "@/generated/prisma";

type EditDeliverySequenceFormRow = {
  id: string;
  name: string;
  sequence: number;
  type: StopType;
  notes: string | null;
};

type EditDeliverySequenceFormProps = {
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

const columnHelper = createColumnHelper<EditDeliverySequenceFormRow>();

export function EditDeliverySequenceForm({
  delivery,
}: EditDeliverySequenceFormProps) {
  const [tableData, setTableData] = useState(
    delivery.stops.map<EditDeliverySequenceFormRow>((stop) => ({
      id: stop.id,
      name: stop.endClientCompany.name,
      sequence: stop.sequence,
      type: stop.type,
      notes: stop.notes,
    })),
  );
  const [isUpdating, setIsUpdating] = useState(false);

  const sensors = useSensors(
    useSensor(PointerSensor, {
      activationConstraint: {
        distance: isUpdating ? Infinity : 8,
      },
    }),
    useSensor(KeyboardSensor, {
      coordinateGetter: sortableKeyboardCoordinates,
      keyboardCodes: {
        start: isUpdating ? [] : ["Space"],
        cancel: ["Escape"],
        end: ["Space"],
      },
    }),
  );

  const columns = useMemo<ColumnDef<EditDeliverySequenceFormRow, any>[]>(
    () => [
      columnHelper.accessor("sequence", {
        header: () => <Text>Ordre</Text>,
        cell: (props) => <Strong>{props.getValue() + 1}</Strong>,
      }),
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
    ],
    [],
  );

  const table = useReactTable({
    data: tableData.sort((a, b) => a.sequence - b.sequence),
    columns,
    getCoreRowModel: getCoreRowModel(),
  });

  const handleDragEnd = async (event: DragEndEvent) => {
    if (isUpdating) {
      return;
    }

    const { active, over } = event;
    if (over && active.id !== over.id) {
      const oldIndex = tableData.findIndex((item) => item.id === active.id);
      const newIndex = tableData.findIndex((item) => item.id === over.id);
      const updatedStops = arrayMove(tableData, oldIndex, newIndex).map(
        (item, index) => ({
          ...item,
          sequence: index,
        }),
      );

      setTableData(updatedStops);
      setIsUpdating(true);

      try {
        await updateSequences({
          deliveryId: delivery.id,
          input: updatedStops.map(({ id, sequence }) => ({ id, sequence })),
        });
      } catch (error) {
        console.error("Failed to update sequences:", error);
        setTableData(tableData);
      } finally {
        setIsUpdating(false);
      }
    }
  };

  const rowIds = useMemo(() => tableData.map((row) => row.id), [tableData]);

  return (
    <DndContext
      sensors={sensors}
      collisionDetection={closestCenter}
      onDragEnd={handleDragEnd}
      modifiers={[restrictToVerticalAxis]}
    >
      <Table
        dense
        striped
        className={clsx(
          "rounded-2xl border border-zinc-950/10 dark:border-white/10",
          isUpdating && "opacity-60",
        )}
      >
        <TableHead>
          {table.getHeaderGroups().map((headerGroup) => (
            <TableRow key={headerGroup.id}>
              <TableHeader className="w-12">
                {isUpdating && (
                  <div className="flex justify-center">
                    <Loader2Icon className="h-3 w-3 animate-spin text-zinc-400" />
                  </div>
                )}
              </TableHeader>
              {headerGroup.headers.map((header) => (
                <TableHeader key={header.id}>
                  {header.isPlaceholder
                    ? null
                    : flexRender(
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
              <TableCell colSpan={columns.length + 1}>
                <EmptyState
                  icon={UserEmpty}
                  title="Vous n’avez pas encore de client"
                  description="Ajoutez votre premier client pour démarrer !"
                />
              </TableCell>
            </TableRow>
          )}

          <SortableContext
            items={rowIds}
            strategy={verticalListSortingStrategy}
          >
            {table.getRowModel().rows.map((row) => (
              <SortableRow
                key={row.original.id}
                row={row}
                isDisabled={isUpdating}
              />
            ))}
          </SortableContext>
        </TableBody>
      </Table>
    </DndContext>
  );
}

type SortableRowProps = {
  row: Row<EditDeliverySequenceFormRow>;
  isDisabled: boolean;
};

function SortableRow({ row, isDisabled }: SortableRowProps) {
  const {
    attributes,
    listeners,
    setNodeRef,
    transform,
    transition,
    isDragging,
  } = useSortable({
    id: row.original.id,
    disabled: isDisabled,
  });

  const style = {
    transform: CSS.Transform.toString(transform),
    transition,
    opacity: isDragging ? 0.5 : 1,
  };

  return (
    <TableRow ref={setNodeRef} style={style}>
      <TableCell>
        <div
          {...attributes}
          {...listeners}
          className={clsx(
            "p-1 rounded transition-colors",
            isDisabled
              ? "cursor-not-allowed opacity-50"
              : "cursor-grab hover:cursor-grabbing hover:bg-zinc-100 dark:hover:bg-white/10",
          )}
        >
          <GripVertical className="h-4 w-4 text-zinc-400" />
        </div>
      </TableCell>
      {row.getVisibleCells().map((cell) => (
        <TableCell key={cell.id}>
          {flexRender(cell.column.columnDef.cell, cell.getContext())}
        </TableCell>
      ))}
    </TableRow>
  );
}
