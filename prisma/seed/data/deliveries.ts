import {
  DeliveryStatus,
  type Prisma,
  StopStatus,
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

/**
 * Generates a unique delivery number based on the current year and sequence
 */
function generateDeliveryNumber(sequence: number): string {
  const year = Time().format("YY");
  const paddedSequence = sequence.toString().padStart(4, "0");
  return `TDS${year}-${paddedSequence}`;
}

/**
 * Creates delivery seed data with various scenarios
 */
export const DELIVERIES: Array<
  (options: DeliveryFactoryOptions) => Prisma.DeliveryCreateInput[]
> = [
  ({ companies, users }) => {
    // Find the delivery company (TDS)
    const deliveryCompany = companies.find((c) => c.type === "DELIVERY");
    if (!deliveryCompany) {
      console.warn("No delivery company found, skipping delivery creation");
      return [];
    }

    // Find client companies
    const clientCompany = companies.find((c) => c.type === "CLIENT");
    if (!clientCompany) {
      console.warn("No client company found, skipping delivery creation");
      return [];
    }

    // Find drivers with vehicles
    const drivers = users.filter(
      (u) => u.vehicle && u.companyId === deliveryCompany.id,
    );
    if (drivers.length === 0) {
      console.warn("No drivers found, skipping delivery creation");
      return [];
    }

    // Get end clients for this client company
    const endClients = companies.filter(
      (c) => c.type === "END_CLIENT" && c.parentId === clientCompany.id,
    );

    if (endClients.length < 3) {
      console.warn("Not enough end clients found, skipping delivery creation");
      return [];
    }

    const [driver1, driver2] = drivers;
    const today = Time();

    // Type-safe access to vehicle properties since we've already filtered for drivers with vehicles
    const driver1Vehicle = driver1.vehicle;
    const driver2Vehicle = driver2?.vehicle;

    if (!driver1Vehicle) {
      console.warn("Driver 1 has no vehicle, skipping delivery creation");
      return [];
    }

    const deliveries: Prisma.DeliveryCreateInput[] = [
      // 1. Today's scheduled delivery (driver 1)
      {
        number: generateDeliveryNumber(1),
        date: dateStringToDate(today.format("YYYY-MM-DD")),
        notes: "Livraison du jour - matériel dentaire standard",
        deliveryStatus: DeliveryStatus.SCHEDULED,
        driverName: `${driver1.firstName} ${driver1.lastName}`,
        vehicleLicensePlate: driver1Vehicle.plate,
        deliveryCompany: { connect: { id: deliveryCompany.id } },
        driver: { connect: { id: driver1.id } },
        vehicle: { connect: { id: driver1Vehicle.id } },
        stops: {
          create: [
            {
              sequence: 0,
              type: StopType.PICKUP,
              status: StopStatus.PLANNED,
              notes: "Récupération au laboratoire ADEIS",
              endClientCompany: { connect: { id: clientCompany.id } },
              address: { connect: { id: clientCompany.addressId } },
            },
            ...endClients.slice(0, 4).map((endClient, index) => ({
              sequence: index + 1,
              type: StopType.DROPOFF,
              status: StopStatus.PLANNED,
              notes: `Livraison ${index + 1} - ${endClient.name}`,
              endClientCompany: { connect: { id: endClient.id } },
              address: { connect: { id: endClient.addressId } },
            })),
          ],
        },
      },

      // 2. Today's in-progress delivery (driver 2)
      {
        number: generateDeliveryNumber(2),
        date: dateStringToDate(today.format("YYYY-MM-DD")),
        notes: "Livraison urgente - prothèses dentaires",
        deliveryStatus: DeliveryStatus.IN_PROGRESS,
        driverName:
          driver2 && driver2Vehicle
            ? `${driver2.firstName} ${driver2.lastName}`
            : `${driver1.firstName} ${driver1.lastName}`,
        vehicleLicensePlate:
          driver2 && driver2Vehicle
            ? driver2Vehicle.plate
            : driver1Vehicle.plate,
        deliveryCompany: { connect: { id: deliveryCompany.id } },
        driver: {
          connect: { id: driver2 && driver2Vehicle ? driver2.id : driver1.id },
        },
        vehicle: {
          connect: {
            id:
              driver2 && driver2Vehicle ? driver2Vehicle.id : driver1Vehicle.id,
          },
        },
        startedAt: dateStringToDate(
          today.hour(8).minute(30).format("YYYY-MM-DD HH:mm:ss"),
        ),
        stops: {
          create: [
            {
              sequence: 0,
              type: StopType.PICKUP,
              status: StopStatus.DELIVERED,
              notes: "Récupération au laboratoire ADEIS",
              completedAt: dateStringToDate(
                today.hour(8).minute(45).format("YYYY-MM-DD HH:mm:ss"),
              ),
              endClientCompany: { connect: { id: clientCompany.id } },
              address: { connect: { id: clientCompany.addressId } },
            },
            {
              sequence: 1,
              type: StopType.DROPOFF,
              status: StopStatus.DELIVERED,
              notes: `Livraison 1 - ${endClients[4].name}`,
              completedAt: dateStringToDate(
                today.hour(9).minute(15).format("YYYY-MM-DD HH:mm:ss"),
              ),
              endClientCompany: { connect: { id: endClients[4].id } },
              address: { connect: { id: endClients[4].addressId } },
            },
            {
              sequence: 2,
              type: StopType.DROPOFF,
              status: StopStatus.EN_ROUTE,
              notes: `Livraison 2 - ${endClients[5].name}`,
              endClientCompany: { connect: { id: endClients[5].id } },
              address: { connect: { id: endClients[5].addressId } },
            },
            {
              sequence: 3,
              type: StopType.DROPOFF,
              status: StopStatus.PLANNED,
              notes: `Livraison 3 - ${endClients[6].name}`,
              endClientCompany: { connect: { id: endClients[6].id } },
              address: { connect: { id: endClients[6].addressId } },
            },
          ],
        },
      },

      // 3. Tomorrow's scheduled delivery
      {
        number: generateDeliveryNumber(3),
        date: dateStringToDate(today.add(1, "day").format("YYYY-MM-DD")),
        notes: "Livraison planifiée pour demain",
        deliveryStatus: DeliveryStatus.SCHEDULED,
        driverName: `${driver1.firstName} ${driver1.lastName}`,
        vehicleLicensePlate: driver1Vehicle.plate,
        deliveryCompany: { connect: { id: deliveryCompany.id } },
        driver: { connect: { id: driver1.id } },
        vehicle: { connect: { id: driver1Vehicle.id } },
        stops: {
          create: [
            {
              sequence: 0,
              type: StopType.PICKUP,
              status: StopStatus.PLANNED,
              notes: "Récupération au laboratoire ADEIS",
              endClientCompany: { connect: { id: clientCompany.id } },
              address: { connect: { id: clientCompany.addressId } },
            },
            ...endClients.slice(7, 12).map((endClient, index) => ({
              sequence: index + 1,
              type: StopType.DROPOFF,
              status: StopStatus.PLANNED,
              notes: `Livraison ${index + 1} - ${endClient.name}`,
              endClientCompany: { connect: { id: endClient.id } },
              address: { connect: { id: endClient.addressId } },
            })),
          ],
        },
      },

      // 4. Yesterday's completed delivery
      {
        number: generateDeliveryNumber(4),
        date: dateStringToDate(today.subtract(1, "day").format("YYYY-MM-DD")),
        notes: "Livraison complétée hier",
        deliveryStatus: DeliveryStatus.COMPLETED,
        driverName: `${driver1.firstName} ${driver1.lastName}`,
        vehicleLicensePlate: driver1Vehicle.plate,
        deliveryCompany: { connect: { id: deliveryCompany.id } },
        driver: { connect: { id: driver1.id } },
        vehicle: { connect: { id: driver1Vehicle.id } },
        startedAt: dateStringToDate(
          today
            .subtract(1, "day")
            .hour(8)
            .minute(0)
            .format("YYYY-MM-DD HH:mm:ss"),
        ),
        finishedAt: dateStringToDate(
          today
            .subtract(1, "day")
            .hour(16)
            .minute(30)
            .format("YYYY-MM-DD HH:mm:ss"),
        ),
        stops: {
          create: [
            {
              sequence: 0,
              type: StopType.PICKUP,
              status: StopStatus.DELIVERED,
              notes: "Récupération au laboratoire ADEIS",
              completedAt: dateStringToDate(
                today
                  .subtract(1, "day")
                  .hour(8)
                  .minute(20)
                  .format("YYYY-MM-DD HH:mm:ss"),
              ),
              endClientCompany: { connect: { id: clientCompany.id } },
              address: { connect: { id: clientCompany.addressId } },
            },
            ...endClients.slice(12, 15).map((endClient, index) => ({
              sequence: index + 1,
              type: StopType.DROPOFF,
              status: StopStatus.DELIVERED,
              notes: `Livraison ${index + 1} - ${endClient.name}`,
              completedAt: dateStringToDate(
                today
                  .subtract(1, "day")
                  .hour(9 + index * 2)
                  .minute(0)
                  .format("YYYY-MM-DD HH:mm:ss"),
              ),
              endClientCompany: { connect: { id: endClient.id } },
              address: { connect: { id: endClient.addressId } },
            })),
          ],
        },
      },

      // 5. Next week's scheduled delivery
      {
        number: generateDeliveryNumber(5),
        date: dateStringToDate(today.add(7, "days").format("YYYY-MM-DD")),
        notes: "Livraison planifiée pour la semaine prochaine",
        deliveryStatus: DeliveryStatus.SCHEDULED,
        deliveryCompany: { connect: { id: deliveryCompany.id } },
        stops: {
          create: [
            {
              sequence: 0,
              type: StopType.PICKUP,
              status: StopStatus.PLANNED,
              notes: "Récupération au laboratoire ADEIS",
              endClientCompany: { connect: { id: clientCompany.id } },
              address: { connect: { id: clientCompany.addressId } },
            },
            ...endClients.slice(15, 20).map((endClient, index) => ({
              sequence: index + 1,
              type: StopType.DROPOFF,
              status: StopStatus.PLANNED,
              notes: `Livraison ${index + 1} - ${endClient.name}`,
              endClientCompany: { connect: { id: endClient.id } },
              address: { connect: { id: endClient.addressId } },
            })),
          ],
        },
      },
    ];

    return deliveries;
  },
];
