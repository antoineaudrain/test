"use client";

import { useDraggable } from "@dnd-kit/core";
import { CSS } from "@dnd-kit/utilities";
import { GripVerticalIcon } from "lucide-react";
import type { DeliveryRequestStopWithDetails } from "@/features/delivery-requests/types";

type EndClient = {
  id: string;
  name: string;
  address: {
    formattedAddress: string;
  };
  requestStops: DeliveryRequestStopWithDetails[];
};

type EndClientCardProps = {
  endClient: EndClient;
  isDragging?: boolean;
};

export function EndClientCard({
  endClient,
  isDragging = false,
}: EndClientCardProps) {
  const {
    attributes,
    listeners,
    setNodeRef,
    transform,
    isDragging: isCurrentlyDragging,
  } = useDraggable({
    id: endClient.id,
  });

  const style = {
    transform: CSS.Translate.toString(transform),
  };

  return (
    <div
      ref={setNodeRef}
      style={style}
      {...attributes}
      {...listeners}
      className={`
        group relative rounded-xl p-4 cursor-grab active:cursor-grabbing
        transition-all duration-200 ease-out
        bg-gradient-to-br from-white to-zinc-50
        dark:from-zinc-800 dark:to-zinc-850
        border-2
        ${
          isCurrentlyDragging || isDragging
            ? "opacity-60 shadow-2xl scale-105 rotate-2 border-blue-400 dark:border-blue-500"
            : "hover:shadow-lg hover:scale-[1.02] hover:-translate-y-0.5 border-zinc-200 dark:border-zinc-700 hover:border-blue-300 dark:hover:border-blue-600"
        }
      `}
    >
      {/* Drag Handle - expanded touch target */}
      <div className="absolute left-0 top-0 bottom-0 w-10 flex items-center justify-center">
        <GripVerticalIcon className="h-5 w-5 text-zinc-300 dark:text-zinc-600 group-hover:text-zinc-400 dark:group-hover:text-zinc-500 transition-colors" />
      </div>

      <div className="flex items-start gap-3 ml-8">
        {/* Icon */}
        {/*<div className="flex-shrink-0 w-10 h-10 rounded-lg bg-blue-50 dark:bg-blue-950/30 flex items-center justify-center">*/}
        {/*  <PackageIcon className="h-5 w-5 text-blue-600 dark:text-blue-400" />*/}
        {/*</div>*/}

        {/* Content */}
        <div className="flex-1 min-w-0">
          <div className="flex items-center gap-2 mb-1.5">
            <h4 className="font-semibold text-zinc-900 dark:text-white truncate text-sm">
              {endClient.name}
            </h4>
            {/*<Badge color="blue" className="shrink-0 text-xs">*/}
            {/*  {endClient.requestStops.length} arrêt{endClient.requestStops.length > 1 ? "s" : ""}*/}
            {/*</Badge>*/}
          </div>

          <div className="flex items-start gap-1.5 text-xs text-zinc-500 dark:text-zinc-400">
            {/*<MapPinIcon className="h-3.5 w-3.5 flex-shrink-0 mt-0.5" />*/}
            <span className="line-clamp-2 leading-relaxed">
              {endClient.address.formattedAddress}
            </span>
          </div>
        </div>
      </div>

      {/* Hover Effect */}
      <div className="absolute inset-0 rounded-xl bg-gradient-to-r from-blue-500/0 via-blue-500/5 to-blue-500/0 opacity-0 group-hover:opacity-100 transition-opacity pointer-events-none" />
    </div>
  );
}
