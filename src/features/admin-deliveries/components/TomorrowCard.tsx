import { CalendarIcon, MapPinIcon, PackageIcon } from "lucide-react";
import Link from "next/link";
import type { DashboardRequestStats } from "@/features/admin-deliveries/actions/queries/getDashboardData";
import {
  Badge,
  Button,
  Card,
  CardContent,
  CardHeader,
  CardTitle,
} from "@/features/shared/components";
import { Time } from "@/lib/time";

type TomorrowCardProps = {
  data: {
    requests: DashboardRequestStats | null;
  };
};

export function TomorrowCard({ data }: TomorrowCardProps) {
  const tomorrow = Time().add(1, "day").format("YYYY-MM-DD");
  const hasRequests = data.requests !== null;

  return (
    <Card>
      <CardHeader>
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-2">
            <CalendarIcon className="h-5 w-5 text-muted-foreground" />
            <CardTitle>Demain</CardTitle>
          </div>
          <Badge color="zinc">
            {Time().add(1, "day").format("DD/MM/YYYY")}
          </Badge>
        </div>
      </CardHeader>
      <CardContent>
        {hasRequests ? (
          <div className="space-y-6">
            <div className="text-center py-6">
              <PackageIcon className="h-12 w-12 text-muted-foreground mx-auto mb-4" />
              <h3 className="text-lg font-semibold mb-2">Demandes reçues</h3>
              <p className="text-sm text-muted-foreground mb-4">
                Préparez les livraisons de demain
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

            <Link href={`/deliveries/new?date=${tomorrow}`} className="block">
              <Button className="w-full" outline>
                <MapPinIcon className="h-4 w-4 mr-2" />
                Voir et Organiser
              </Button>
            </Link>
          </div>
        ) : (
          <div className="text-center py-12">
            <PackageIcon className="h-12 w-12 text-muted-foreground mx-auto mb-4" />
            <h3 className="text-lg font-semibold mb-2">Aucune demande</h3>
            <p className="text-sm text-muted-foreground">
              Aucune demande de livraison pour demain
            </p>
          </div>
        )}
      </CardContent>
    </Card>
  );
}
