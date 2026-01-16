import { ChevronLeftIcon } from "lucide-react";
import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { listClients } from "@/features/clients/actions/queries/listClients";
import { getExistingDeliveryRequestDates } from "@/features/delivery-requests/actions/queries/getExistingDeliveryRequestDates";
import { NewDeliveryRequestForm } from "@/features/delivery-requests/components/NewDeliveryRequestForm";
import { Heading, Link } from "@/features/shared/components";
import prisma from "@/lib/database/prisma";
import { requireAuth } from "@/lib/permissions";

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

  const request = await prisma.deliveryRequest.findUnique({
    where: { id },
    include: {
      stops: {
        include: {
          address: true,
          endClientCompany: true,
          deliveryStop: {
            include: {
              delivery: true,
            },
          },
        },
        orderBy: {
          sequence: "asc",
        },
      },
      clientCompany: true,
      deliveryCompany: true,
    },
  });

  if (!request) {
    notFound();
  }

  // Fetch end clients for the table
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
            <Heading>Modifier demande de livraison</Heading>
          </div>
        </div>

        <NewDeliveryRequestForm
          mode="edit"
          request={request}
          endClients={endClients}
          existingDeliveryRequestDates={existingDeliveryRequestDates}
        />
      </div>
    </>
  );
}
