import { type Prisma, StopType } from "@/generated/prisma";
import { dateStringToDate, Time } from "@/lib/time";

type Company = Prisma.CompanyGetPayload<{
  include: { address: true; clientCompanies: { include: { address: true } } };
}>;

export type DeliveryRequestFactoryOptions = {
  companies: Company[];
};

/**
 * Creates delivery request seed data
 * Delivery requests are created by client companies and sent to delivery companies
 */
export const DELIVERY_REQUESTS: Array<
  (
    options: DeliveryRequestFactoryOptions,
  ) => Prisma.DeliveryRequestCreateInput[]
> = [
  ({ companies }) => {
    // Find the delivery company (TDS)
    const deliveryCompany = companies.find((c) => c.type === "DELIVERY");
    if (!deliveryCompany) {
      console.warn(
        "No delivery company found, skipping delivery request creation",
      );
      return [];
    }

    // Find client companies
    const clientCompany = companies.find((c) => c.type === "CLIENT");
    if (!clientCompany) {
      console.warn(
        "No client company found, skipping delivery request creation",
      );
      return [];
    }

    // Get end clients for this client company
    const endClients = companies.filter(
      (c) => c.type === "END_CLIENT" && c.parentId === clientCompany.id,
    );

    if (endClients.length < 3) {
      console.warn(
        "Not enough end clients found, skipping delivery request creation",
      );
      return [];
    }

    const today = Time();

    const deliveryRequests: Prisma.DeliveryRequestCreateInput[] = [
      // 1. Delivery request for tomorrow
      {
        date: dateStringToDate(today.add(2, "days").format("YYYY-MM-DD")),
        notes: "Demande de livraison pour après-demain - matériel dentaire",
        clientCompany: { connect: { id: clientCompany.id } },
        deliveryCompany: { connect: { id: deliveryCompany.id } },
        stops: {
          create: [
            {
              sequence: 0,
              type: StopType.PICKUP,
              notes: "Récupération au laboratoire ADEIS",
              endClientCompany: { connect: { id: clientCompany.id } },
              address: { connect: { id: clientCompany.addressId } },
            },
            ...endClients.slice(20, 24).map((endClient, index) => ({
              sequence: index + 1,
              type: StopType.DROPOFF,
              notes: `Livraison ${index + 1} - ${endClient.name}`,
              endClientCompany: { connect: { id: endClient.id } },
              address: { connect: { id: endClient.addressId } },
            })),
          ],
        },
      },

      // 2. Delivery request for next week
      {
        date: dateStringToDate(today.add(5, "days").format("YYYY-MM-DD")),
        notes: "Demande de livraison pour la semaine prochaine",
        clientCompany: { connect: { id: clientCompany.id } },
        deliveryCompany: { connect: { id: deliveryCompany.id } },
        stops: {
          create: [
            {
              sequence: 0,
              type: StopType.PICKUP,
              notes: "Récupération au laboratoire ADEIS",
              endClientCompany: { connect: { id: clientCompany.id } },
              address: { connect: { id: clientCompany.addressId } },
            },
            ...endClients.slice(24, 29).map((endClient, index) => ({
              sequence: index + 1,
              type: StopType.DROPOFF,
              notes: `Livraison ${index + 1} - ${endClient.name}`,
              endClientCompany: { connect: { id: endClient.id } },
              address: { connect: { id: endClient.addressId } },
            })),
          ],
        },
      },
    ];

    return deliveryRequests;
  },
];
