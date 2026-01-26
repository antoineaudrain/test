import { CalendarIcon, MapPinIcon, PackageIcon, TruckIcon } from "lucide-react";
import Link from "next/link";
import type { DashboardData } from "@/features/admin-deliveries/actions/queries/getDashboardData";
import {
  Badge,
  Button,
  Card,
  CardContent,
  CardHeader,
  CardTitle,
} from "@/features/shared/components";
import { Time, todayDateString } from "@/lib/time";

type TodayCardProps = {
  data: DashboardData["today"];
};

export function TodayCard({ data }: TodayCardProps) {
  const today = todayDateString();
  const hasDeliveries = data.deliveries.length > 0;
  const hasRequests = data.requests !== null;

  return (
    <Card>
      <CardHeader>
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-2">
            <CalendarIcon className="h-5 w-5 text-muted-foreground" />
            <CardTitle>Aujourd'hui</CardTitle>
          </div>
          <Badge color="zinc">{Time().format("DD/MM/YYYY")}</Badge>
        </div>
      </CardHeader>
      <CardContent>
        {hasDeliveries ? (
          <div className="space-y-4">
            <div className="grid grid-cols-3 gap-4">
              <div className="text-center">
                <div className="text-3xl font-bold">
                  {data.deliveries.length}
                </div>
                <div className="text-sm text-muted-foreground">Livraisons</div>
              </div>
              <div className="text-center">
                <div className="text-3xl font-bold">
                  {data.deliveries.reduce((sum, d) => sum + d.stops.length, 0)}
                </div>
                <div className="text-sm text-muted-foreground">Arrêts</div>
              </div>
              <div className="text-center">
                <div className="text-3xl font-bold">
                  {new Set(data.deliveries.map((d) => d.driverId)).size}
                </div>
                <div className="text-sm text-muted-foreground">Chauffeurs</div>
              </div>
            </div>

            <div className="space-y-2">
              {data.deliveries.map((delivery) => (
                <Link
                  key={delivery.id}
                  href={`/deliveries/${delivery.id}`}
                  className="block p-3 rounded-lg border hover:bg-accent transition-colors"
                >
                  <div className="flex items-center justify-between">
                    <div className="flex items-center gap-3">
                      <TruckIcon className="h-4 w-4 text-muted-foreground" />
                      <div>
                        <div className="font-medium">{delivery.number}</div>
                        <div className="text-sm text-muted-foreground">
                          {delivery.stops.length} arrêt
                          {delivery.stops.length > 1 ? "s" : ""}
                        </div>
                      </div>
                    </div>
                    <Badge
                      color={
                        delivery.deliveryStatus === "COMPLETED"
                          ? "emerald"
                          : delivery.deliveryStatus === "IN_PROGRESS"
                            ? "blue"
                            : "zinc"
                      }
                    >
                      {delivery.deliveryStatus === "COMPLETED"
                        ? "Terminée"
                        : delivery.deliveryStatus === "IN_PROGRESS"
                          ? "En cours"
                          : "Planifiée"}
                    </Badge>
                  </div>
                </Link>
              ))}
            </div>

            {hasRequests && (
              <div className="pt-4 border-t">
                <div className="text-sm text-muted-foreground mb-2">
                  Demandes non assignées
                </div>
                <div className="flex items-center justify-between">
                  <div className="text-sm">
                    {data.requests?.stopsCount} arrêts de{" "}
                    {data.requests?.clientsCount} client
                    {(data.requests?.clientsCount ?? 0) > 1 ? "s" : ""}
                  </div>
                  <Link href={`/deliveries/new?date=${today}`}>
                    <Button outline>Organiser</Button>
                  </Link>
                </div>
              </div>
            )}
          </div>
        ) : hasRequests ? (
          <div className="space-y-6">
            <div className="text-center py-6">
              <PackageIcon className="h-12 w-12 text-muted-foreground mx-auto mb-4" />
              <h3 className="text-lg font-semibold mb-2">
                Demandes en attente
              </h3>
              <p className="text-sm text-muted-foreground mb-4">
                Organisez les livraisons d'aujourd'hui
              </p>
            </div>

            <div className="grid grid-cols-3 gap-4">
              <div className="text-center">
                <div className="text-2xl font-bold">
                  {data.requests?.clientsCount}
                </div>
                <div className="text-sm text-muted-foreground">Clients</div>
              </div>
              <div className="text-center">
                <div className="text-2xl font-bold">
                  {data.requests?.endClientsCount}
                </div>
                <div className="text-sm text-muted-foreground">Arrêts</div>
              </div>
              <div className="text-center">
                <div className="text-2xl font-bold">
                  {data.requests?.stopsCount}
                </div>
                <div className="text-sm text-muted-foreground">Livraisons</div>
              </div>
            </div>

            <Link href={`/deliveries/new?date=${today}`} className="block">
              <Button className="w-full">
                <MapPinIcon className="h-4 w-4 mr-2" />
                Organiser les Livraisons
              </Button>
            </Link>
          </div>
        ) : (
          <div className="text-center py-12">
            <PackageIcon className="h-12 w-12 text-muted-foreground mx-auto mb-4" />
            <h3 className="text-lg font-semibold mb-2">Aucune demande</h3>
            <p className="text-sm text-muted-foreground">
              Aucune demande de livraison pour aujourd'hui
            </p>
          </div>
        )}
      </CardContent>
    </Card>
  );
}
