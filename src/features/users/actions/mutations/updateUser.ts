"use server";

import type { UserJSON } from "@clerk/backend";
import { UpdateUserSchema } from "@/features/users/schemas/updateUser";
import prisma from "@/lib/database/prisma";

export async function updateUser(args: UserJSON) {
  const input = UpdateUserSchema.parse(args);

  const email = input.email_addresses?.[0]?.email_address;
  if (!email) {
    throw new Error("No email found in Clerk payload");
  }

  return prisma.user.update({
    where: {
      externalId: input.id,
    },
    data: {
      email,
      firstName: input.first_name ?? "",
      lastName: input.last_name ?? "",
      // updatedAt is handled automatically by Prisma @updatedAt
      // Never manually set this field - Prisma ensures it's always current
    },
  });
}
