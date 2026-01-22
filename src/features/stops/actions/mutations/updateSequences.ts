"use server";

import { revalidatePath } from "next/cache";
import prisma from "@/lib/database/prisma";
import { withAuth } from "@/lib/permissions";

type StopsInput = {
  id: string;
  sequence: number;
};

type UpdateSequencesProps = {
  deliveryId: string;
  input: StopsInput[];
};

export async function updateSequences({
  deliveryId,
  input,
}: UpdateSequencesProps): Promise<void> {
  return withAuth<void>(async (ctx, _policies) => {
    const delivery = await prisma.delivery.findFirst({
      where: {
        id: deliveryId,
        OR: [
          { deliveryCompanyId: ctx.company.id },
        ],
      },
      include: {
        stops: true,
      },
    });

    if (!delivery) throw new Error("Delivery not found");

    // Update sequences sequentially
    for (const { id, sequence } of input) {
      await prisma.stop.update({
        where: {
          id,
          delivery: {
            id: deliveryId,
            OR: [
              { deliveryCompanyId: ctx.company.id },
            ],
          },
        },
        data: { sequence },
      });
    }

    revalidatePath("/deliveries");
    revalidatePath(`/deliveries/${delivery.id}`);
  });
}
