"use server";

import type { DeliveryWithRelations } from "@/features/deliveries/types";
import prisma from "@/lib/database/prisma";
import { withAuth } from "@/lib/permissions";

export type GetDeliveryReturn = DeliveryWithRelations<{
  deliveryCompany: true;
  driver: true;
  vehicle: true;
  stops: {
    include: {
      endClientCompany: {
        include: {
          address: true;
        };
      };
      address: true;
      sourceRequestStop: {
        include: {
          request: {
            include: {
              clientCompany: true;
            };
          };
        };
      };
    };
  };
}> | null;

type GetDeliveryProps = {
  deliveryId: string;
};

export async function getDelivery({
  deliveryId,
}: GetDeliveryProps): Promise<GetDeliveryReturn> {
  return withAuth<GetDeliveryReturn>(async (ctx, policies) => {
    // Build where clause based on company type
    const whereClause: any = { id: deliveryId };

    if (policies.isDeliveryCompany()) {
      // Delivery companies can only view their own deliveries
      whereClause.deliveryCompanyId = ctx.company.id;
    } else if (policies.isClientCompany()) {
      // Client companies can view deliveries with stops to their end clients
      whereClause.stops = {
        some: {
          endClientCompany: {
            parentId: ctx.company.id,
          },
        },
      };
    }

    // Build stops filter based on company type
    const stopsWhere: any = {};
    if (policies.isClientCompany()) {
      // Client companies can only see stops for their own end clients
      stopsWhere.endClientCompany = {
        parentId: ctx.company.id,
      };
    }

    const delivery = await prisma.delivery.findFirst({
      where: whereClause,
      include: {
        deliveryCompany: true,
        driver: true,
        vehicle: true,
        stops: {
          where: stopsWhere,
          include: {
            endClientCompany: {
              include: {
                address: true,
              },
            },
            address: true,
            sourceRequestStop: {
              include: {
                request: {
                  include: {
                    clientCompany: true,
                  },
                },
              },
            },
          },
        },
      },
    });

    if (!delivery) throw new Error("Delivery not found");
    policies.canViewDelivery(delivery);

    return delivery;
  });
}
