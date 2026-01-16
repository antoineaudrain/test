import type { Metadata } from "next";

import { Heading } from "@/features/shared/components";
import { listVehicles } from "@/features/vehicles/actions/queries/listVehicles";
import {
  VehicleTable,
  type VehicleTableRow,
} from "@/features/vehicles/components/VehicleTable";
import { requirePermission } from "@/lib/permissions";

export const metadata: Metadata = {
  title: "Véhicules",
  description: "Gérez et suivez la flotte de votre entreprise",
};

export default async function VehicleListPage() {
  await requirePermission((policies) => policies.canViewVehicleListPage());

  const vehicles = await listVehicles();
  const data = vehicles.map<VehicleTableRow>((vehicle) => {
    const driver = vehicle.drivers?.[0];
    return {
      id: vehicle.id,
      model: vehicle.model ?? null,
      plate: vehicle.plate,
      driverId: driver?.id ?? null,
      driverName: driver ? `${driver.lastName} ${driver.firstName}` : null,
      createdAt: vehicle.createdAt,
    };
  });

  return (
    <div className="space-y-8">
      <div className="flex flex-wrap items-end justify-between gap-4">
        <div className="flex flex-col max-sm:w-full sm:flex-1 gap-y-2">
          <Heading>Véhicules</Heading>
        </div>
      </div>

      <VehicleTable data={data} />
    </div>
  );
}
