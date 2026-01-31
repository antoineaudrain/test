import type { Metadata } from "next";
import { getTodayDeliveryStats } from "@/features/deliveries/actions/queries/getTodayDeliveryStats";
import { listDelivery } from "@/features/deliveries/actions/queries/listDelivery";
import { DeliveryCallout } from "@/features/deliveries/components/DeliveryCallout";
import {
  DeliveryTable,
  type DeliveryTableRow,
} from "@/features/deliveries/components/DeliveryTable";
import { listTodayDeliveryRequestsForDeliveryCompany } from "@/features/delivery-requests/actions/queries/listTodayDeliveryRequestsForDeliveryCompany";
import {
  DeliveryRequestTable,
  type DeliveryRequestTableRow,
} from "@/features/delivery-requests/components/DeliveryRequestTable";
import { Heading } from "@/features/shared/components";
import { checkPermission, requirePermission } from "@/lib/permissions";
import { formatDateString } from "@/lib/time";

export const metadata: Metadata = {
  title: "Mes livraisons",
  description: "Gérez et suivez vos livraisons pour aujourd'hui",
};

export default async function DeliveriesPage() {
  await requirePermission((policies) => policies.canViewDeliveryListPage());

  const deliveries = await listDelivery();
  const todayStats = await getTodayDeliveryStats();

  // Check if user can see driver filter (admin/manager in delivery companies)
  const { hasPermission: showDriverFilter } = await checkPermission(
    (policies) => {
      if (
        !policies.isDeliveryCompany() ||
        (!policies.isAdmin() && !policies.isManager())
      ) {
        throw new Error("Not authorized");
      }
    },
  );

  // Check if user is a delivery company to show delivery requests
  const { hasPermission: isDeliveryCompany } = await checkPermission(
    (policies) => {
      if (!policies.isDeliveryCompany()) {
        throw new Error("Not a delivery company");
      }
    },
  );

  // Fetch today's delivery requests for delivery companies
  const todayDeliveryRequests = isDeliveryCompany
    ? await listTodayDeliveryRequestsForDeliveryCompany()
    : [];

  const data = deliveries.map<DeliveryTableRow>((delivery) => ({
    id: delivery.id,
    number: delivery.number,
    deliveryStatus: delivery.deliveryStatus ?? undefined,
    date: delivery.date,
    driver: delivery.driver
      ? {
          firstName: delivery.driver.firstName,
          lastName: delivery.driver.lastName,
        }
      : null,
  }));

  const deliveryRequestData =
    todayDeliveryRequests.map<DeliveryRequestTableRow>((request) => ({
      id: request.id,
      date: formatDateString(request.date),
      clientCompanyName: request.clientCompany?.name ?? "Client inconnu",
      endClients: request.stops.map((stop) => ({
        name: stop.endClientCompany?.name ?? "Client inconnu",
        hasPickup: stop.type === "PICKUP" || stop.type === "BOTH",
        hasDropoff: stop.type === "DROPOFF" || stop.type === "BOTH",
      })),
      notes: request.notes,
    }));

  return (
    <div className="space-y-8">
      <DeliveryCallout
        ongoingDelivery={todayStats.ongoingDelivery}
        deliveryRequestStats={todayStats.deliveryRequestStats}
        todayDeliveries={todayStats.todayDeliveries}
        unassignedStopsCount={todayStats.unassignedStopsCount}
      />

      {isDeliveryCompany && todayDeliveryRequests.length > 0 && (
        <DeliveryRequestTable data={deliveryRequestData} />
      )}

      <div className="flex flex-wrap items-end justify-between gap-4">
        <div className="flex flex-col max-sm:w-full sm:flex-1 gap-y-2">
          <Heading>Toutes mes livraisons</Heading>
        </div>
      </div>

      <DeliveryTable data={data} showDriverFilter={showDriverFilter} />
    </div>
  );
}
