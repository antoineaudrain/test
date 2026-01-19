import type { Metadata } from "next";
import { getTodayDeliveryStats } from "@/features/deliveries/actions/queries/getTodayDeliveryStats";
import { listDelivery } from "@/features/deliveries/actions/queries/listDelivery";
import { DeliveryCallout } from "@/features/deliveries/components/DeliveryCallout";
import {
  DeliveryTable,
  type DeliveryTableRow,
} from "@/features/deliveries/components/DeliveryTable";
import { Button, Heading } from "@/features/shared/components";
import { checkPermission, requirePermission } from "@/lib/permissions";

export const metadata: Metadata = {
  title: "Mes livraisons",
  description: "Gérez et suivez vos livraisons pour aujourd'hui",
};

export default async function DeliveriesPage() {
  await requirePermission((policies) => policies.canViewDeliveryListPage());

  const deliveries = await listDelivery();
  const todayStats = await getTodayDeliveryStats();
  const { hasPermission: canViewNewPage } = await checkPermission((policies) =>
    policies.canViewDeliveryNewPage(),
  );

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

  return (
    <div className="space-y-8">
      <div className="flex flex-wrap items-end justify-between gap-4">
        <div className="flex flex-col max-sm:w-full sm:flex-1 gap-y-2">
          <Heading>Livraisons</Heading>
        </div>
      </div>

      <DeliveryCallout
        ongoingDelivery={todayStats.ongoingDelivery}
        deliveryRequestStats={todayStats.deliveryRequestStats}
        todayDeliveries={todayStats.todayDeliveries}
      />

      <DeliveryTable data={data} showDriverFilter={showDriverFilter} />
    </div>
  );
}
