import { ChevronLeftIcon } from "lucide-react";
import type { Metadata } from "next";
import { listClients } from "@/features/clients/actions/queries/listClients";
import { getExistingDeliveryRequestDates } from "@/features/delivery-requests/actions/queries/getExistingDeliveryRequestDates";
import { NewDeliveryRequestForm } from "@/features/delivery-requests/components/NewDeliveryRequestForm";
import { Heading, Link } from "@/features/shared/components";
import { requirePermission } from "@/lib/permissions";

export const metadata: Metadata = {
  title: "Nouvelle Demande de Livraison",
  description: "Créer une nouvelle demande de livraison",
};

export default async function NewDeliveryRequestPage() {
  await requirePermission((policies) =>
    policies.canViewDeliveryRequestNewPage(),
  );

  // Fetch end clients that belong to the current client company
  const endClients = await listClients();
  const existingDeliveryRequestDates = await getExistingDeliveryRequestDates();

  return (
    <>
      <div className="max-lg:hidden">
        <Link
          href="/delivery-requests"
          className="inline-flex items-center gap-2 text-sm/6 text-zinc-500 dark:text-zinc-400"
        >
          <ChevronLeftIcon className="size-4 text-zinc-400 dark:text-zinc-500" />
          Retour
        </Link>
      </div>

      <div className="flex flex-col gap-3 lg:gap-6">
        <div className="flex flex-wrap items-end justify-between gap-4">
          <div className="flex items-center gap-4">
            <Heading>Nouvelle demande de livraison</Heading>
          </div>
        </div>

        <NewDeliveryRequestForm
          mode="create"
          endClients={endClients}
          existingDeliveryRequestDates={existingDeliveryRequestDates}
        />
      </div>
    </>
  );
}
