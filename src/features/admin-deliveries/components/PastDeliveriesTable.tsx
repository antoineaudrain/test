"use client";

import { Loader2 } from "lucide-react";
import { useEffect, useState, useTransition } from "react";
import { getPastDeliveries } from "@/features/admin-deliveries/actions/queries/getPastDeliveries";
import {
  Badge,
  Button,
  Link,
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/features/shared/components";
import { Time } from "@/lib/time";

type PastDeliveriesData = Awaited<ReturnType<typeof getPastDeliveries>>;

export function PastDeliveriesTable() {
  const [page, setPage] = useState(1);
  const [data, setData] = useState<PastDeliveriesData | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [isPending, startTransition] = useTransition();
  const pageSize = 10;

  useEffect(() => {
    startTransition(async () => {
      try {
        setError(null);
        const result = await getPastDeliveries({ page, pageSize });
        setData(result);
      } catch (err) {
        setError(
          err instanceof Error ? err.message : "Une erreur est survenue",
        );
      }
    });
  }, [page]);

  if (isPending && !data) {
    return (
      <div className="flex items-center justify-center py-12">
        <Loader2 className="h-8 w-8 animate-spin text-zinc-500 dark:text-zinc-400" />
      </div>
    );
  }

  if (error) {
    return (
      <div className="text-center py-12">
        <p className="text-red-600 dark:text-red-400">
          Erreur lors du chargement des livraisons
        </p>
      </div>
    );
  }

  if (!data || data.deliveries.length === 0) {
    return (
      <div className="text-center py-12 border border-zinc-200 dark:border-zinc-700 rounded-lg">
        <p className="text-zinc-600 dark:text-zinc-400">
          Aucune livraison passée
        </p>
      </div>
    );
  }

  return (
    <div className="space-y-4">
      <Table striped>
        <TableHead>
          <TableRow>
            <TableHeader>Numéro</TableHeader>
            <TableHeader>Date</TableHeader>
            <TableHeader>Client</TableHeader>
            <TableHeader>Chauffeur</TableHeader>
            <TableHeader>Véhicule</TableHeader>
            <TableHeader>Arrêts</TableHeader>
            <TableHeader>Statut</TableHeader>
            <TableHeader />
          </TableRow>
        </TableHead>
        <TableBody>
          {data.deliveries.map((delivery) => (
            <TableRow key={delivery.id}>
              <TableCell className="font-medium">{delivery.number}</TableCell>
              <TableCell>{Time(delivery.date).format("DD/MM/YYYY")}</TableCell>
              <TableCell>{delivery.clientCompany?.name}</TableCell>
              <TableCell>
                {delivery.driver
                  ? `${delivery.driver.firstName} ${delivery.driver.lastName}`
                  : "-"}
              </TableCell>
              <TableCell>{delivery.vehicle?.plate ?? "-"}</TableCell>
              <TableCell>{delivery.stops.length}</TableCell>
              <TableCell>
                <Badge
                  color={
                    delivery.deliveryStatus === "COMPLETED"
                      ? "green"
                      : delivery.deliveryStatus === "CANCELLED"
                        ? "red"
                        : "zinc"
                  }
                >
                  {delivery.deliveryStatus === "COMPLETED"
                    ? "Terminée"
                    : delivery.deliveryStatus === "CANCELLED"
                      ? "Annulée"
                      : "En cours"}
                </Badge>
              </TableCell>
              <TableCell>
                <Link href={`/deliveries/${delivery.id}`}>
                  <Button outline>Voir</Button>
                </Link>
              </TableCell>
            </TableRow>
          ))}
        </TableBody>
      </Table>

      {/* Pagination */}
      {data.pagination.totalPages > 1 && (
        <div className="flex items-center justify-between">
          <div className="text-sm text-zinc-600 dark:text-zinc-400">
            Page {data.pagination.page} sur {data.pagination.totalPages} •{" "}
            {data.pagination.total} livraison
            {data.pagination.total > 1 ? "s" : ""}
          </div>
          <div className="flex gap-2">
            <Button
              outline
              disabled={page === 1 || isPending}
              onClick={() => setPage((p) => p - 1)}
            >
              Précédent
            </Button>
            <Button
              outline
              disabled={page === data.pagination.totalPages || isPending}
              onClick={() => setPage((p) => p + 1)}
            >
              Suivant
            </Button>
          </div>
        </div>
      )}
    </div>
  );
}
