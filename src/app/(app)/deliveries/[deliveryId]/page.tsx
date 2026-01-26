import { CalendarDaysIcon, ChevronLeftIcon, UserIcon } from "lucide-react";
import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { DeliveryMap } from "@/features/addresses/components/Map";
import { getDelivery } from "@/features/deliveries/actions/queries/getDelivery";
import { DeleteDeliveryButton } from "@/features/deliveries/components/DeleteDeliveryButton";
import { DeliveryLabel } from "@/features/deliveries/components/DeliveryLabel";
import { DeliveryRequestNotes } from "@/features/deliveries/components/DeliveryRequestNotes";
import {
  DeliveryStopTable,
  type DeliveryStopTableRow,
} from "@/features/deliveries/components/DeliveryStopTable";
import { EditDeliverySequenceForm } from "@/features/deliveries/components/EditDeliverySequenceForm";
import { ResumeDeliveryButton } from "@/features/deliveries/components/ResumeDeliveryButton";
import { StartDeliveryButton } from "@/features/deliveries/components/StartDeliveryButton";
import { StatusBadge } from "@/features/deliveries/components/StatusBadge";
import { WaybillButton } from "@/features/deliveries/components/WaybillButton";
import { Heading, Link, Subheading, Text } from "@/features/shared/components";
import {
  checkPermission,
  requireAuth,
  requirePermission,
} from "@/lib/permissions";
import { Time } from "@/lib/time";

type DeliveryDetailsPageProps = {
  params: Promise<{ deliveryId: string }>;
};

export async function generateMetadata({
  params,
}: DeliveryDetailsPageProps): Promise<Metadata> {
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
}: DeliveryDetailsPageProps) {
  await requirePermission((policies) => policies.canViewDeliveryDetailsPage());

  const { deliveryId } = await params;
  const delivery = await getDelivery({ deliveryId });
  if (!delivery) {
    notFound();
  }

  // Get current user's company info
  const { ctx, policies } = await requireAuth();
  const isClientCompany = policies.isClientCompany();

  const { hasPermission: canDeleteDelivery } = await checkPermission(
    (policies) => policies.canDeleteDeliveries(delivery),
  );
  const { hasPermission: canEditDeliverySequence } = await checkPermission(
    (policies) => policies.canUpdateDeliverySequence(delivery),
  );
  const { hasPermission: canViewDeliveryStopTable } = await checkPermission(
    (policies) => policies.canViewDeliveryStopTable(delivery),
  );
  const { hasPermission: canStartDelivery } = await checkPermission(
    (policies) => policies.canStartDelivery(delivery),
  );
  const { hasPermission: canResumeDelivery } = await checkPermission(
    (policies) => policies.canResumeDelivery(delivery),
  );
  const { hasPermission: canOpenWaybill } = await checkPermission((policies) =>
    policies.canOpenWaybill(delivery),
  );

  const data = delivery.stops.map<DeliveryStopTableRow>((stop) => ({
    id: stop.id,
    name: stop.endClientCompany.name,
    sequence: stop.sequence,
    type: stop.type,
    notes: stop.notes,
    status: stop.status,
    driverNotes: stop.driverNotes,
    imageUrl: stop.imageUrl,
    completedAt: stop.completedAt,
  }));

  // Build markers array only for stops with valid coordinates
  const markers = delivery.stops
    .filter(
      (stop) =>
        stop.endClientCompany.address.longitude != null &&
        stop.endClientCompany.address.latitude != null,
    )
    .map((stop) => ({
      longitude: parseFloat(String(stop.endClientCompany.address.longitude)),
      latitude: parseFloat(String(stop.endClientCompany.address.latitude)),
    }));

  return (
    <>
      <div className="max-lg:hidden">
        <Link
          href="/deliveries"
          className="inline-flex items-center gap-2 text-sm/6 text-zinc-500 dark:text-zinc-400"
        >
          <ChevronLeftIcon className="size-4 text-zinc-400 dark:text-zinc-500" />
          Retour
        </Link>
      </div>

      <div className="flex flex-col gap-4 lg:gap-8">
        <div>
          <div className="flex flex-wrap items-end justify-between gap-4">
            <div className="flex items-center gap-4">
              <Heading>
                <DeliveryLabel number={delivery.number} date={delivery.date} />
              </Heading>
              <StatusBadge
                deliveryStatus={delivery.deliveryStatus ?? undefined}
              />
            </div>

            <div className="flex flex-wrap items-center gap-2">
              {canDeleteDelivery && (
                <DeleteDeliveryButton deliveryId={delivery.id} />
              )}
              {canStartDelivery && (
                <StartDeliveryButton deliveryId={delivery.id} />
              )}
              {canResumeDelivery && (
                <ResumeDeliveryButton deliveryId={delivery.id} />
              )}
              {canOpenWaybill && <WaybillButton delivery={delivery} />}
            </div>
          </div>

          <div className="isolate mt-2.5 flex flex-wrap justify-between gap-x-6 gap-y-4">
            <div className="flex flex-wrap gap-x-10 gap-y-4 py-1.5">
              <div className="flex items-center gap-3 text-base/6 text-zinc-950 sm:text-sm/6 dark:text-white">
                <CalendarDaysIcon className="size-4 shrink-0 text-zinc-400 dark:text-zinc-500" />
                <span>{Time(delivery.date).format("LL")}</span>
              </div>
              {delivery.driver && (
                <div className="flex items-center gap-3 text-base/6 text-zinc-950 sm:text-sm/6 dark:text-white">
                  <UserIcon className="size-4 shrink-0 text-zinc-400 dark:text-zinc-500" />
                  <span>
                    {delivery.driver?.lastName} {delivery.driver?.firstName}
                  </span>
                </div>
              )}
            </div>
          </div>
        </div>

        {delivery.deliveryStatus === "IN_PROGRESS" && (
          <div className="w-full max-w-none">
            <div className="relative w-full h-[280px] sm:h-[320px] md:h-[400px] lg:h-[480px] rounded-xl overflow-hidden border border-gray-200 shadow-sm bg-gray-100">
              <DeliveryMap markers={markers} />
            </div>
          </div>
        )}

        {canEditDeliverySequence && (
          <EditDeliverySequenceForm delivery={delivery} />
        )}

        {canViewDeliveryStopTable && <DeliveryStopTable data={data} />}

        <div>
          <Subheading>Notes des demandes</Subheading>
          <DeliveryRequestNotes
            delivery={delivery}
            currentUserCompanyId={ctx.company.id}
            isClientCompany={isClientCompany}
          />
        </div>

        {delivery.deliveryStatus === "COMPLETED" && (
          <div>
            <Subheading>Notes du livreur</Subheading>
            {delivery.driverNotes ? (
              <Text>{delivery.driverNotes}</Text>
            ) : (
              <Text className="italic opacity-30">Pas de notes</Text>
            )}
          </div>
        )}
      </div>
    </>
  );
}
