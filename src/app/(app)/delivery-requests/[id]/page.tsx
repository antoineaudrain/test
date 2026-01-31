import { ChevronLeftIcon } from "lucide-react";
import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { listClients } from "@/features/clients/actions/queries/listClients";
import { getDeliveryRequest } from "@/features/delivery-requests/actions/queries/getDeliveryRequest";
import { getExistingDeliveryRequestDates } from "@/features/delivery-requests/actions/queries/getExistingDeliveryRequestDates";
import { NewDeliveryRequestForm } from "@/features/delivery-requests/components/NewDeliveryRequestForm";
import { Heading, Link } from "@/features/shared/components";
import { checkPermission, requireAuth } from "@/lib/permissions";

type PageProps = {
  params: Promise<{ id: string }>;
};

export const metadata: Metadata = {
  title: "Modifier Demande de Livraison",
  description: "Modifier une demande de livraison",
};

export default async function DeliveryRequestDetailPage({ params }: PageProps) {
  await requireAuth();
  const { id } = await params;

  const request = await getDeliveryRequest({ requestId: id });

  if (!request) {
    notFound();
  }

  // Check if user is a delivery company (read-only access)
  const { hasPermission: isDeliveryCompany } = await checkPermission(
    (policies) => {
      if (!policies.isDeliveryCompany()) {
        throw new Error("Not a delivery company");
      }
    },
  );

  // For delivery companies, use end clients from the request only
  // For client companies, fetch all end clients for editing
  const endClients = isDeliveryCompany
    ? request.stops.map((stop) => ({
        id: stop.endClientCompany?.id ?? "",
        name: stop.endClientCompany?.name ?? "Client inconnu",
        addressId: stop.address?.id ?? "",
        address: {
          formattedAddress: stop.address?.formattedAddress ?? "",
        },
      }))
    : await listClients();
  const existingDeliveryRequestDates = await getExistingDeliveryRequestDates();

  return (
    <>
      <div className="max-lg:hidden">
        <Link
          href={isDeliveryCompany ? "/deliveries" : "/delivery-requests"}
          className="inline-flex items-center gap-2 text-sm/6 text-zinc-500 dark:text-zinc-400"
        >
          <ChevronLeftIcon className="size-4 text-zinc-400 dark:text-zinc-500" />
          Retour
        </Link>
      </div>

      <div className="flex flex-col gap-3 lg:gap-6">
        <div className="flex flex-wrap items-end justify-between gap-4">
          <div className="flex items-center gap-4">
            <Heading>
              {isDeliveryCompany
                ? "Consulter demande de livraison"
                : "Modifier demande de livraison"}
            </Heading>
          </div>
        </div>

        <NewDeliveryRequestForm
          mode="edit"
          request={request}
          endClients={endClients}
          existingDeliveryRequestDates={existingDeliveryRequestDates}
          readOnly={isDeliveryCompany}
        />
      </div>
    </>
  );
}
