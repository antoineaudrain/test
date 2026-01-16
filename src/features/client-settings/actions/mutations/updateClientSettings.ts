"use server";

import { revalidatePath } from "next/cache";
import {
  type UpdateClientSettingsInput,
  UpdateClientSettingsSchema,
} from "@/features/admin-deliveries/schemas/saveDeliveries";
import prisma from "@/lib/database/prisma";
import { withAuth } from "@/lib/permissions";

export async function updateClientSettings(
  input: UpdateClientSettingsInput,
): Promise<void> {
  return withAuth<void>(async (ctx, policies) => {
    // 1. Validate permissions
    policies.canUpdateClientSettings();

    // 2. Validate input
    const validatedInput = UpdateClientSettingsSchema.parse(input);

    // 3. Verify client company exists and is a child of current company
    const clientCompany = await prisma.company.findUnique({
      where: { id: validatedInput.clientCompanyId },
    });

    if (!clientCompany) {
      throw new Error("Client company not found");
    }

    if (clientCompany.parentId !== ctx.company.id) {
      throw new Error("Can only update settings for own client companies");
    }

    // 4. Upsert settings
    await prisma.clientSettings.upsert({
      where: {
        clientCompanyId: validatedInput.clientCompanyId,
      },
      create: {
        clientCompanyId: validatedInput.clientCompanyId,
        cutoffTime: validatedInput.cutoffTime,
      },
      update: {
        cutoffTime: validatedInput.cutoffTime,
      },
    });

    // 5. Revalidate paths
    revalidatePath("/clients");
    revalidatePath(`/clients/${validatedInput.clientCompanyId}`);
  });
}
