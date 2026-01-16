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
import { GripVertical, Loader2Icon } from "lucide-react";
import { useMemo, useState } from "react";
import {
  Strong,
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
  Text,
} from "@/features/shared/components";

type ReorderableClientTableRow = {
  id: string;
  sequence: number;
  displayName: string;
  address: string;
};

type ReorderableClientTableProps = {
  clientId: string;
  data: ReorderableClientTableRow[];
};

const columnHelper = createColumnHelper<ReorderableClientTableRow>();

export function ReorderableClientTable({
  clientId: _clientId,
  data,
}: ReorderableClientTableProps) {
  const [tableData, setTableData] = useState<ReorderableClientTableRow[]>(data);
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

  const columns = useMemo(
    () => [
      columnHelper.accessor("sequence", {
        header: () => <Text>Ordre</Text>,
        cell: (props) => <Strong>{props.getValue()}</Strong>,
      }),
      columnHelper.accessor("displayName", {
        header: () => <Text>Nom</Text>,
        cell: (props) => <Strong>{props.getValue()}</Strong>,
        enableSorting: true,
        sortingFn: "alphanumeric",
      }),
      columnHelper.accessor("address", {
        header: () => <Text>Adresse</Text>,
        cell: (props) => <Text>{props.getValue()}</Text>,
        enableSorting: false,
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
          sequence: index + 1,
        }),
      );

      setTableData(updatedStops);
      setIsUpdating(true);

      // TODO: Re-enable when updateSequences is implemented
      // await updateSequences({
      //   clientId,
      //   input: updatedStops.map(({ id, sequence }) => ({ id, sequence })),
      // });

      setIsUpdating(false);
    }
  };

  const rowIds = useMemo(() => tableData.map((row) => row.id), [tableData]);

  if (tableData.length === 0) {
    return (
      <div className="text-center py-12 text-zinc-500 dark:text-zinc-400">
        No delivery stops found
      </div>
    );
  }

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
  row: Row<ReorderableClientTableRow>;
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
