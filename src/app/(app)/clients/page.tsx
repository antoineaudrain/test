import type { Metadata } from "next";
import { listClients } from "@/features/clients/actions/queries/listClients";
import {
  ClientTable,
  type ClientTableRow,
} from "@/features/clients/components/ClientTable";
import { Button, Heading } from "@/features/shared/components";
import { checkPermission, requirePermission } from "@/lib/permissions";

export const metadata: Metadata = {
  title: "Clients",
  description: "Gérez et suivez vos clients",
};

export default async function ClientListPage() {
  await requirePermission((policies) => policies.canViewClientListPage());

  const clients = await listClients();
  const data = clients.map<ClientTableRow>((client) => ({
    id: client.id,
    displayName: client.name,
    address: `${client.address.address}, ${client.address.postalCode} ${client.address.city}`,
    createdAt: client.createdAt,
  }));

  const viewNewPage = await checkPermission((policies) =>
    policies.canViewClientNewPage(),
  );

  return (
    <div className="space-y-8">
      <div className="flex flex-wrap items-end justify-between gap-4">
        <div className="flex flex-col max-sm:w-full sm:flex-1 gap-y-2">
          <Heading>Clients</Heading>
        </div>

        {viewNewPage.hasPermission && (
          <Button href="/clients/new">Ajouter Client</Button>
        )}
      </div>

      <ClientTable data={data} />
    </div>
  );
}
