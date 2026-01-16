"use server";

import type { DeliveryWithRelations } from "@/features/deliveries/types";
import prisma from "@/lib/database/prisma";
import { withAuth } from "@/lib/permissions";

export type GetDeliveryReturn = DeliveryWithRelations<{
  deliveryCompany: true;
  clientCompany: {
    include: {
      address: true;
    };
  };
  driver: true;
  vehicle: true;
  stops: {
    include: {
      endClientCompany: {
        include: {
          address: true;
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
    const delivery = await prisma.delivery.findFirst({
      where: {
        id: deliveryId,
        OR: [
          { deliveryCompanyId: ctx.company.id },
          { clientCompanyId: ctx.company.id },
        ],
      },
      include: {
        deliveryCompany: true,
        clientCompany: {
          include: {
            address: true,
          },
        },
        driver: true,
        vehicle: true,
        stops: {
          include: {
            endClientCompany: {
              include: {
                address: true,
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
