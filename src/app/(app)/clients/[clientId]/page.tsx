"use server";

import { ChevronLeftIcon } from "lucide-react";
import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { getClient } from "@/features/clients/actions/queries/getClient";
import type { EndClientDefaultStopTypeRow } from "@/features/clients/components/EndClientDefaultStopTypeTable";
import { EndClientDefaultStopTypeTable } from "@/features/clients/components/EndClientDefaultStopTypeTable";
import { UpdateClientForm } from "@/features/clients/components/UpdateClientForm";
import {
  Divider,
  Heading,
  Link,
  Subheading,
} from "@/features/shared/components";
import {
  checkPermission,
  requireAuth,
  requirePermission,
} from "@/lib/permissions";

type ClientDetailsPageProps = {
  params: Promise<{ clientId: string }>;
};

export async function generateMetadata({
  params,
}: ClientDetailsPageProps): Promise<Metadata> {
  const { clientId } = await params;
  const client = await getClient({ clientId });
  if (!client) {
    notFound();
  }

  return {
    title: `${client.name}`,
  };
}

export default async function ClientDetailsPage({
  params,
}: ClientDetailsPageProps) {
  await requirePermission((policies) => policies.canViewClientDetailsPage());

  const { clientId } = await params;
  const client = await getClient({ clientId });
  if (!client) notFound();

  const { hasPermission: canUpdate } = await checkPermission((p) =>
    p.canUpdateClient(client),
  );

  const { ctx } = await requireAuth();
  const isDeliveryCompanyViewingClient =
    ctx.company.type === "DELIVERY" && client.type === "CLIENT";

  const endClientsData: EndClientDefaultStopTypeRow[] =
    isDeliveryCompanyViewingClient
      ? [...client.clientCompanies]
          .sort((a, b) => a.createdAt.getTime() - b.createdAt.getTime())
          .map((endClient) => ({
            id: endClient.id,
            name: endClient.name,
            address: endClient.address.formattedAddress,
            defaultStopType: endClient.defaultStopType,
            createdAt: endClient.createdAt,
          }))
      : [];

  return (
    <>
      <div className="max-lg:hidden">
        <Link
          href="/clients"
          className="inline-flex items-center gap-2 text-sm/6 text-zinc-500 dark:text-zinc-400"
        >
          <ChevronLeftIcon className="size-4 text-zinc-400 dark:text-zinc-500" />
          Retour
        </Link>
      </div>

      <div className="flex flex-col gap-3 lg:gap-6">
        <div className="flex flex-wrap items-end justify-between gap-4">
          <div className="flex items-center gap-4">
            <Heading>{client.name}</Heading>
          </div>
        </div>

        <div className="flex flex-col gap-3 lg:gap-6">
          <UpdateClientForm
            disabled={!canUpdate}
            clientId={client.id}
            clientType={client.type}
            defaultValues={{
              ...client,
              address: {
                ...(client.address.externalId && {
                  externalId: client.address.externalId,
                }),
                address: client.address.address,
                city: client.address.city,
                state: client.address.state,
                postalCode: client.address.postalCode,
                country: client.address.country,
                formattedAddress: client.address.formattedAddress,
                ...(client.address.latitude != null && {
                  latitude: parseFloat(String(client.address.latitude)),
                }),
                ...(client.address.longitude != null && {
                  longitude: parseFloat(String(client.address.longitude)),
                }),
              },
              cutoffTime: client.clientSettings?.cutoffTime || null,
            }}
          />

          {isDeliveryCompanyViewingClient && endClientsData.length > 0 && (
            <>
              <Divider />
              <div className="space-y-6">
                <Subheading>Types d'arrêt par défaut</Subheading>
                <EndClientDefaultStopTypeTable
                  clientId={client.id}
                  data={endClientsData}
                />
              </div>
            </>
          )}
        </div>
      </div>
    </>
  );
}
