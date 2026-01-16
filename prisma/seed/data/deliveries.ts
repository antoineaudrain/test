import {
  DeliveryStatus,
  type Prisma,
  StopType,
} from "@/generated/prisma";
import { dateStringToDate, Time } from "@/lib/time";

type Company = Prisma.CompanyGetPayload<{
  include: { address: true; clientCompanies: { include: { address: true } } };
}>;
type User = Prisma.UserGetPayload<{ include: { vehicle: true } }>;

export type DeliveryFactoryOptions = {
  companies: Company[];
  users: User[];
};

export const DELIVERIES: Array<
  (options: DeliveryFactoryOptions) => Prisma.DeliveryCreateInput[]
> = [
  ({ companies, users }) => {
    // Find the delivery company (TDS)
    const deliveryCompany = companies.find((c) => c.type === "DELIVERY");
    if (!deliveryCompany) return [];

    // Find client companies
    const clientCompany = companies.find((c) => c.type === "CLIENT");
    if (!clientCompany) return [];

    // Find a driver with a vehicle
    const driver = users.find(
      (u) => u.vehicle && u.companyId === deliveryCompany.id,
    );
    if (!driver || !driver.vehicle) return [];

    // Get end clients for this client company
    const endClients = companies.filter(
      (c) => c.type === "END_CLIENT" && c.parentId === clientCompany.id,
    );

    if (endClients.length === 0) return [];

    // Create a sample delivery
    const deliveries: Prisma.DeliveryCreateInput[] = [
      {
        number: `TDS${Time().format("YY")}-0001`,
        date: dateStringToDate(Time().add(1, "day").format("YYYY-MM-DD")),
        notes: "Livraison standard - matériel dentaire",
        deliveryStatus: DeliveryStatus.SCHEDULED,
        driverName: `${driver.firstName} ${driver.lastName}`,
        vehicleLicensePlate: driver.vehicle.plate,
        deliveryCompany: { connect: { id: deliveryCompany.id } },
        clientCompany: { connect: { id: clientCompany.id } },
        driver: { connect: { id: driver.id } },
        vehicle: { connect: { id: driver.vehicle.id } },
        stops: {
          create: endClients.slice(0, 3).map((endClient, index) => ({
            sequence: index,
            type: index === 0 ? StopType.PICKUP : StopType.DROPOFF,
            notes: "Livraison standard",
            endClientCompany: { connect: { id: endClient.id } },
            address: { connect: { id: endClient.addressId } },
          })),
        },
      },
    ];

    return deliveries;
  },
];
