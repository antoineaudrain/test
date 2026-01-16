"use client";

import { useDroppable } from "@dnd-kit/core";
import { CheckCircle2Icon, ChevronDownIcon, PackageIcon } from "lucide-react";
import { useState } from "react";
import type { DeliveryRequestStopWithDetails } from "@/features/delivery-requests/types";
import { EndClientCard } from "./EndClientCard";

type EndClient = {
  id: string;
  name: string;
  address: {
    formattedAddress: string;
  };
  requestStops: DeliveryRequestStopWithDetails[];
};

type UnassignedPoolProps = {
  endClients: EndClient[];
};

export function UnassignedPool({ endClients }: UnassignedPoolProps) {
  const [isCollapsed, setIsCollapsed] = useState(true);
  const { setNodeRef, isOver } = useDroppable({
    id: "unassigned",
  });

  const totalStops = endClients.reduce(
    (sum, ec) => sum + ec.requestStops.length,
    0,
  );

  return (
    <div className="sticky top-4">
      {/* Mobile Collapse Header */}
      <button
        type="button"
        onClick={() => setIsCollapsed(!isCollapsed)}
        className="lg:hidden w-full flex items-center justify-between p-4 rounded-xl bg-amber-50 dark:bg-amber-950/30 border-2 border-amber-200 dark:border-amber-700 mb-2 transition-all hover:bg-amber-100 dark:hover:bg-amber-950/40"
      >
        <div className="flex items-center gap-2">
          <PackageIcon className="h-5 w-5 text-amber-600 dark:text-amber-400" />
          <span className="font-semibold text-zinc-900 dark:text-white">
            {endClients.length} client{endClients.length > 1 ? "s" : ""} final
            {endClients.length > 1 ? "aux" : ""}
          </span>
          <span className="text-sm text-zinc-600 dark:text-zinc-400">
            ({totalStops} arrêt{totalStops > 1 ? "s" : ""})
          </span>
        </div>
        <ChevronDownIcon
          className={`h-5 w-5 text-zinc-600 dark:text-zinc-400 transition-transform ${isCollapsed ? "" : "rotate-180"}`}
        />
      </button>

      <div
        ref={setNodeRef}
        className={`
          rounded-2xl border-2 border-dashed p-5 min-h-0 lg:min-h-[500px]
          transition-all duration-300 ease-out
          ${isCollapsed ? "hidden lg:block" : ""}
          ${
            isOver
              ? "border-blue-500 bg-gradient-to-br from-blue-50 to-blue-100 dark:from-blue-950/40 dark:to-blue-900/30 shadow-lg scale-[1.02]"
              : "border-zinc-300 dark:border-zinc-700 bg-zinc-50/50 dark:bg-zinc-900/50"
          }
        `}
      >
        {/* Header */}
        <div className="mb-5 pb-4 border-b border-zinc-200 dark:border-zinc-700">
          <div className="flex items-center gap-3 mb-2">
            <div className="p-2 rounded-lg bg-amber-100 dark:bg-amber-900/30">
              <PackageIcon className="h-5 w-5 text-amber-600 dark:text-amber-400" />
            </div>
            <div className="flex-1">
              <h3 className="font-bold text-base text-zinc-900 dark:text-white">
                Clients finaux non assignés
              </h3>
              <p className="text-xs text-zinc-500 dark:text-zinc-400">
                Glissez vers les livraisons
              </p>
            </div>
          </div>

          <div className="flex items-center gap-4 mt-3">
            <div className="flex items-center gap-2 text-sm">
              <span className="font-semibold text-amber-600 dark:text-amber-400 text-lg">
                {endClients.length}
              </span>
              <span className="text-zinc-600 dark:text-zinc-400">
                client{endClients.length > 1 ? "s" : ""} final
                {endClients.length > 1 ? "aux" : ""}
              </span>
            </div>
            <div className="h-4 w-px bg-zinc-300 dark:bg-zinc-600" />
            <div className="flex items-center gap-2 text-sm">
              <span className="font-semibold text-amber-600 dark:text-amber-400 text-lg">
                {totalStops}
              </span>
              <span className="text-zinc-600 dark:text-zinc-400">
                arrêt{totalStops > 1 ? "s" : ""}
              </span>
            </div>
          </div>
        </div>

        {/* Content */}
        {endClients.length === 0 ? (
          <div className="flex flex-col items-center justify-center py-16 text-center">
            <div className="rounded-full p-4 bg-green-100 dark:bg-green-900/30 mb-4">
              <CheckCircle2Icon className="h-10 w-10 text-green-600 dark:text-green-400" />
            </div>
            <h4 className="font-semibold text-zinc-900 dark:text-white mb-2">
              Tout est assigné !
            </h4>
            <p className="text-sm text-zinc-500 dark:text-zinc-400">
              Tous les clients finaux ont été attribués aux livraisons
            </p>
          </div>
        ) : (
          <div className="space-y-3">
            {endClients.map((endClient) => (
              <EndClientCard key={endClient.id} endClient={endClient} />
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
