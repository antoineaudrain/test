import {
  Navigation2Icon,
  PackageMinusIcon,
  PackagePlusIcon,
} from "lucide-react";
import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { DeliveryMap } from "@/features/addresses/components/Map";
import {
  Button,
  Heading,
  Subheading,
  Text,
} from "@/features/shared/components";
import { getStop } from "@/features/stops/actions/queries/getStop";
import { CompleteStopButton } from "@/features/stops/components/CompleteStopButton";
import { FailStopButton } from "@/features/stops/components/FailStopButton";
import { StopStatus } from "@/generated/prisma";

export const metadata: Metadata = {
  title: "Livraisons",
  description: "Gérez vos livraisons et suivez leur statut",
};

type DeliverStopPageProps = {
  params: Promise<{ deliveryId: string; stopId: string }>;
};

export default async function DeliveryStopPage({
  params,
}: DeliverStopPageProps) {
  const { deliveryId, stopId } = await params;
  const stop = await getStop({ deliveryId, stopId });
  if (!stop) {
    notFound();
  }

  // Build markers array only if coordinates are available
  const markers =
    stop.address.longitude != null && stop.address.latitude != null
      ? [
          {
            longitude: parseFloat(String(stop.address.longitude)),
            latitude: parseFloat(String(stop.address.latitude)),
          },
        ]
      : [];

  const hasCoordinates = markers.length > 0;

  return (
    <div className="flex flex-col gap-6">
      <div className="w-full max-w-none">
        <div className="relative w-full h-[280px] sm:h-[320px] md:h-[400px] lg:h-[480px] rounded-xl overflow-hidden border border-gray-200 shadow-sm bg-gray-100">
          <DeliveryMap markers={markers} />
        </div>
      </div>

      <div className="flex flex-col gap-6">
        <div className="flex flex-col gap-2">
          <Heading>{stop.endClientCompany.name}</Heading>
          <Subheading>{stop.address.formattedAddress}</Subheading>
          {!hasCoordinates && (
            <div className="flex items-center gap-2 text-sm text-amber-600 dark:text-amber-500 bg-amber-50 dark:bg-amber-950/20 px-3 py-2 rounded-md border border-amber-200 dark:border-amber-800">
              <span className="text-base">⚠️</span>
              <span>
                Adresse saisie manuellement. Utilisez la navigation pour vous
                guider.
              </span>
            </div>
          )}
        </div>

        {stop.status === StopStatus.EN_ROUTE && (
          <div className="grid grid-cols-3 gap-4">
            <Button
              outline
              target="_blank"
              href={`https://waze.com/ul?q=${encodeURIComponent(stop.address.formattedAddress)}`}
            >
              <div className="py-1.5 flex flex-col items-center text-blue-500 fill-blue-500">
                <Navigation2Icon className="h-5 w-5" />
                Naviguer
              </div>
            </Button>

            <div className="w-full col-span-2 flex flex-row">
              <FailStopButton deliveryId={deliveryId} stopId={stopId} />
              <CompleteStopButton deliveryId={deliveryId} stopId={stopId} />
            </div>
          </div>
        )}

        {stop.status === StopStatus.FAILED && (
          <div className="h-17 flex items-center justify-center rounded-lg bg-red-500/15 text-red-700 group-data-hover:bg-red-500/25 dark:bg-red-500/10 dark:text-red-400 dark:group-data-hover:bg-red-500/20">
            Livraison annulée
          </div>
        )}

        {stop.status === StopStatus.DELIVERED && (
          <div className="h-17 flex items-center justify-center rounded-lg bg-green-500/15 text-green-700 group-data-hover:bg-green-500/25 dark:bg-green-500/10 dark:text-green-400 dark:group-data-hover:bg-green-500/20">
            Livraison completée
          </div>
        )}

        <div className="flex flex-col gap-4">
          <div className="flex flex-col gap-3">
            <Subheading>Notes</Subheading>
            {stop.notes ? (
              <Text>{stop.notes}</Text>
            ) : (
              <Text className="italic opacity-30">Pas de notes</Text>
            )}
          </div>

          <div className="flex flex-col gap-3">
            <Subheading>Colis</Subheading>
            <div className="flex flex-col gap-3">
              {["BOTH", "DROPOFF"].includes(stop.type) && (
                <div className="flex flex-row items-start gap-3">
                  <PackageMinusIcon className="mt-0.5 h-5 w-5 text-zinc-500 dark:text-zinc-400" />
                  <Text>Livrer</Text>
                </div>
              )}
              {["BOTH", "PICKUP"].includes(stop.type) && (
                <div className="flex flex-row items-start gap-3">
                  <PackagePlusIcon className="mt-0.5 h-5 w-5 text-zinc-500 dark:text-zinc-400" />
                  <Text>Collecter</Text>
                </div>
              )}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
