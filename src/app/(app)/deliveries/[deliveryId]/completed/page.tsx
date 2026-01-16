import { CheckCircleIcon } from "lucide-react";
import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { getDelivery } from "@/features/deliveries/actions/queries/getDelivery";
import { CompletedDeliveryForm } from "@/features/deliveries/components/CompletedDeliveryForm";
import { Heading, Text } from "@/features/shared/components";
import { Confetti } from "@/features/shared/components/confetti";
import { requirePermission } from "@/lib/permissions";
import { Time } from "@/lib/time";

type DeliveryCompletePageProps = {
  params: Promise<{ deliveryId: string }>;
};

export async function generateMetadata({
  params,
}: DeliveryCompletePageProps): Promise<Metadata> {
  const { deliveryId } = await params;
  const delivery = await getDelivery({ deliveryId });
  if (!delivery) {
    notFound();
  }

  return {
    title: delivery.number ?? "Livraison",
  };
}

export default async function DeliveryDetailsPage({
  params,
}: DeliveryCompletePageProps) {
  const { deliveryId } = await params;
  const delivery = await getDelivery({ deliveryId });
  if (!delivery) {
    notFound();
  }

  await requirePermission((policies) =>
    policies.canViewDeliveryCompletedPage(delivery),
  );
  const finishedAt = Time();
  const totalStops = delivery.stops.length ?? 0;
  const completedStops =
    delivery.stops.filter((stop) => stop.status === "DELIVERED").length ?? 0;

  return (
    <div className="flex items-center justify-center p-6">
      <Confetti />

      <div className="w-full max-w-md">
        <div className="text-center mb-8">
          <div className="inline-flex items-center justify-center w-20 h-20 bg-green-100 rounded-full mb-6">
            <CheckCircleIcon className="w-10 h-10 text-green-600" />
          </div>

          <Heading>Tournée terminée !</Heading>
          <Text>Merci Jean, excellent travail aujourd'hui.</Text>
        </div>

        <div className="grid grid-cols-1 gap-px sm:grid-cols-2 lg:grid-cols-2">
          <div className="flex flex-col items-center px-4 py-6 sm:px-6 lg:px-8">
            <Text>Clients livrés</Text>
            <Heading>
              {completedStops}/{totalStops}
            </Heading>
          </div>

          <div className="flex flex-col items-center px-4 py-6 sm:px-6 lg:px-8">
            <Text>Heure de fin</Text>
            <Heading>{finishedAt.format("HH:mm")}</Heading>
          </div>
        </div>

        <CompletedDeliveryForm
          deliveryId={deliveryId}
          finishedAt={finishedAt.toDate()}
        />
      </div>
    </div>
  );
}
