import { PlusIcon } from "lucide-react";
import Link from "next/link";
import { listDeliveryRequests } from "@/features/delivery-requests/actions/queries/listDeliveryRequests";
import {
  Badge,
  Button,
  Heading,
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/features/shared/components";
import { requireAuth, requirePermission } from "@/lib/permissions";
import { Time } from "@/lib/time";

export default async function DeliveryRequestsPage() {
  await requireAuth();
  await requirePermission((policies) =>
    policies.canViewDeliveryRequestListPage(),
  );

  const requests = await listDeliveryRequests();

  return (
    <div className="container mx-auto py-8 space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <Heading level={1}>Demandes de Livraison</Heading>
          <p className="text-zinc-600 dark:text-zinc-400 mt-1">
            Gérez vos demandes de livraison
          </p>
        </div>
        <Link href="/delivery-requests/new">
          <Button>
            <PlusIcon className="h-4 w-4 mr-2" />
            Nouvelle Demande
          </Button>
        </Link>
      </div>

      {requests.length === 0 ? (
        <div className="text-center py-12 border-2 border-dashed border-zinc-300 dark:border-zinc-700 rounded-lg">
          <p className="text-zinc-600 dark:text-zinc-400">
            Aucune demande de livraison
          </p>
          <Link href="/delivery-requests/new">
            <Button className="mt-4">Créer une demande</Button>
          </Link>
        </div>
      ) : (
        <Table striped>
          <TableHead>
            <TableRow>
              <TableHeader>Date</TableHeader>
              <TableHeader>Arrêts</TableHeader>
              <TableHeader>Livraisons Assignées</TableHeader>
              <TableHeader>Statut</TableHeader>
              <TableHeader />
            </TableRow>
          </TableHead>
          <TableBody>
            {requests.map((request) => {
              const assignedStops = request.stops.filter(
                (s) => s.deliveryStopId,
              ).length;
              const allAssigned = assignedStops === request.stops.length;
              const someAssigned = assignedStops > 0 && !allAssigned;

              // Get unique deliveries with their statuses
              const allDeliveries = request.stops
                .map((s) => s.deliveryStop?.delivery)
                .filter(
                  (d): d is NonNullable<typeof d> =>
                    d !== null && d !== undefined,
                );

              const uniqueDeliveries = Array.from(
                new Map(allDeliveries.map((d) => [d.id, d] as const)).values(),
              );

              // Get unique delivery numbers for display
              const deliveryNumbers = new Set(
                uniqueDeliveries.map((d) => d.number),
              );

              // Check delivery statuses
              const hasInProgressDelivery = uniqueDeliveries.some(
                (d) => d.deliveryStatus === "IN_PROGRESS",
              );
              const allDeliveriesCompleted =
                allAssigned &&
                uniqueDeliveries.length > 0 &&
                uniqueDeliveries.every((d) => d.deliveryStatus === "COMPLETED");

              // Determine badge status
              let badgeColor: "blue" | "green" | "amber" | "zinc";
              let badgeText: string;

              if (hasInProgressDelivery) {
                badgeColor = "blue";
                badgeText = "En cours";
              } else if (allDeliveriesCompleted) {
                badgeColor = "green";
                badgeText = "Terminé";
              } else if (allAssigned) {
                badgeColor = "green";
                badgeText = "Entièrement assigné";
              } else if (someAssigned) {
                badgeColor = "amber";
                badgeText = "Partiellement assigné";
              } else {
                badgeColor = "zinc";
                badgeText = "Non assigné";
              }

              return (
                <TableRow key={request.id}>
                  <TableCell className="font-medium">
                    {Time(request.date).format("DD/MM/YYYY")}
                  </TableCell>
                  <TableCell>
                    {request.stops.length} arrêt
                    {request.stops.length > 1 ? "s" : ""}
                  </TableCell>
                  <TableCell>
                    {deliveryNumbers.size > 0 ? (
                      <div className="flex flex-wrap gap-1">
                        {Array.from(deliveryNumbers).map((number) => (
                          <Badge key={number} color="blue">
                            {number}
                          </Badge>
                        ))}
                      </div>
                    ) : (
                      <span className="text-zinc-500 dark:text-zinc-400">
                        Aucune
                      </span>
                    )}
                  </TableCell>
                  <TableCell>
                    <Badge color={badgeColor}>{badgeText}</Badge>
                  </TableCell>
                  <TableCell>
                    <div className="flex gap-2">
                      <Link href={`/delivery-requests/${request.id}`}>
                        <Button outline>Voir</Button>
                      </Link>
                    </div>
                  </TableCell>
                </TableRow>
              );
            })}
          </TableBody>
        </Table>
      )}
    </div>
  );
}
