import { redirect } from "next/navigation";
import { getDeliveryCreationData } from "@/features/admin-deliveries/actions/queries/getDeliveryCreationData";
import { DeliveryCreationInterface } from "@/features/admin-deliveries/components/DeliveryCreationInterface";
import { requireAuth, requirePermission } from "@/lib/permissions";
import { Time } from "@/lib/time";

type PageProps = {
  searchParams: Promise<{ date?: string }>;
};

export default async function DeliveryCreationPage({
  searchParams,
}: PageProps) {
  await requireAuth();
  await requirePermission((policies) => policies.canViewDeliveryCreationPage());

  const params = await searchParams;
  const date = params.date || Time().format("YYYY-MM-DD");

  // Validate date format
  if (!/^\d{4}-\d{2}-\d{2}$/.test(date)) {
    redirect(`/deliveries/new?date=${Time().format("YYYY-MM-DD")}`);
  }

  const data = await getDeliveryCreationData(date);

  return (
    <div className="container mx-auto px-4 py-4 sm:px-6 sm:py-6 lg:py-8 max-w-7xl">
      <DeliveryCreationInterface initialData={data} />
    </div>
  );
}
