import {
  AlertCircleIcon,
  ArrowRightIcon,
  BuildingIcon,
  MapPinIcon,
  PackageCheckIcon, TruckIcon,
} from "lucide-react";
import Link from "next/link";
import { Button, Card, CardContent } from "@/features/shared/components";

type OngoingDelivery = {
  id: string;
  number: string;
  deliveryStatus: string;
  stopsCount: number;
  completedStopsCount: number;
};

type DeliveryRequestStats = {
  clientsCount: number;
  endClientsCount: number;
};

type TodayDeliverySummary = {
  id: string;
  number: string;
  deliveryStatus: string;
  driverName: string | null;
  stopsCount: number;
  completedStopsCount: number;
};

type DeliveryCalloutProps = {
  ongoingDelivery: OngoingDelivery | null;
  deliveryRequestStats: DeliveryRequestStats | null;
  todayDeliveries: TodayDeliverySummary[];
  unassignedStopsCount: number;
};

export function DeliveryCallout({
  ongoingDelivery,
  deliveryRequestStats,
  todayDeliveries,
  unassignedStopsCount,
}: DeliveryCalloutProps) {
  // Don't show anything if there's no data
  if (
    !ongoingDelivery &&
    !deliveryRequestStats &&
    todayDeliveries.length === 0
  ) {
    return null;
  }

  // Show today's deliveries if they exist (but no ongoing delivery)
  if (todayDeliveries.length > 0) {
    // Calculate total stops and completed stops
    const totalStops = todayDeliveries.reduce(
      (sum, delivery) => sum + delivery.stopsCount,
      0,
    );
    const completedStops = todayDeliveries.reduce(
      (sum, delivery) => sum + delivery.completedStopsCount,
      0,
    );

    return (
      <div className="space-y-4">
        {/* Alert banner for unassigned stops */}
        {unassignedStopsCount > 0 && (
          <div className="bg-amber-50 dark:bg-amber-950/20 border border-amber-200 dark:border-amber-800 rounded-lg p-4">
            <div className="flex items-start gap-3">
              <AlertCircleIcon className="h-5 w-5 text-amber-600 dark:text-amber-400 flex-shrink-0 mt-0.5" />
              <div className="flex-1">
                <p className="font-medium text-amber-900 dark:text-amber-100">
                  Arrêts non assignés
                </p>
                <p className="text-sm text-amber-700 dark:text-amber-300 mt-1">
                  {unassignedStopsCount} arrêt{unassignedStopsCount > 1 ? "s" : ""} de demandes de
                  livraison {unassignedStopsCount > 1 ? "ne sont" : "n'est"} pas encore assigné
                  {unassignedStopsCount > 1 ? "s" : ""} à une livraison. Cliquez sur le bouton
                  ci-dessous pour les ajouter.
                </p>
              </div>
            </div>
          </div>
        )}

        {/* Main card */}
        <Card>
          <CardContent className="py-4">
            <div className="flex items-start gap-4">
              <div className="rounded-full bg-zinc-100 p-3 dark:bg-zinc-800">
                <PackageCheckIcon className="h-6 w-6 text-zinc-600 dark:text-zinc-400" />
              </div>
              <div className="flex-1 min-w-0">
                <h3 className="text-lg font-semibold text-zinc-900 dark:text-white">
                  Livraisons d'aujourd'hui
                </h3>
                <p className="text-sm text-zinc-600 dark:text-zinc-400 mt-1">
                  Gérez et modifiez vos livraisons en cours
                </p>
                <div className="flex items-center gap-6 mt-3">
                  <div className="flex items-center gap-2">
                    <TruckIcon className="h-4 w-4 text-zinc-600 dark:text-zinc-400" />
                    <span className="text-sm font-medium text-zinc-900 dark:text-white">
                      {todayDeliveries.length} livraison
                      {todayDeliveries.length > 1 ? "s" : ""}
                    </span>
                  </div>
                  <div className="flex items-center gap-2">
                    <MapPinIcon className="h-4 w-4 text-zinc-600 dark:text-zinc-400" />
                    <span className="text-sm font-medium text-zinc-900 dark:text-white">
                      {completedStops}/{totalStops} arrêts complétés
                    </span>
                  </div>
                </div>
              </div>
              <Link href="/deliveries/new">
                <Button>
                  Modifier les livraisons
                  <ArrowRightIcon className="h-4 w-4 ml-2" />
                </Button>
              </Link>
            </div>
          </CardContent>
        </Card>
      </div>
    );
  }

  // Show delivery request stats callout
  if (deliveryRequestStats) {
    return (
      <Card className="border-l-4 border-l-amber-500 bg-amber-50/50 dark:bg-amber-950/20">
        <CardContent className="py-4">
          <div className="flex items-start gap-4">
            <div className="rounded-full bg-amber-100 p-3 dark:bg-amber-900/50">
              <PackageCheckIcon className="h-6 w-6 text-amber-600 dark:text-amber-400" />
            </div>
            <div className="flex-1 min-w-0">
              <h3 className="text-lg font-semibold text-amber-900 dark:text-amber-100">
                Demandes de livraison en attente
              </h3>
              <p className="text-sm text-amber-700 dark:text-amber-300 mt-1">
                Prêt à organiser les livraisons d'aujourd'hui
              </p>
              <div className="flex items-center gap-6 mt-3">
                <div className="flex items-center gap-2">
                  <BuildingIcon className="h-4 w-4 text-amber-600 dark:text-amber-400" />
                  <span className="text-sm font-medium text-amber-900 dark:text-amber-100">
                    {deliveryRequestStats.clientsCount} client
                    {deliveryRequestStats.clientsCount > 1 ? "s" : ""}
                  </span>
                </div>
                <div className="flex items-center gap-2">
                  <MapPinIcon className="h-4 w-4 text-amber-600 dark:text-amber-400" />
                  <span className="text-sm font-medium text-amber-900 dark:text-amber-100">
                    {deliveryRequestStats.endClientsCount} arrêt
                    {deliveryRequestStats.endClientsCount > 1 ? "s" : ""}
                  </span>
                </div>
              </div>
            </div>
            <Link href="/deliveries/new">
              <Button className="whitespace-nowrap bg-amber-600 hover:bg-amber-700 text-white">
                Créer les livraisons
                <ArrowRightIcon className="h-4 w-4 ml-2" />
              </Button>
            </Link>
          </div>
        </CardContent>
      </Card>
    );
  }

  return null;
}
