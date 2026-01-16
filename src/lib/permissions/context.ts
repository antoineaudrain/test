"use server";

import { auth, clerkClient } from "@clerk/nextjs/server";
import type { Prisma } from "@/generated/prisma";
import prisma from "@/lib/database/prisma";

type UserWithRelations = Prisma.UserGetPayload<{
  include: { company: { include: { parentCompany: true } }; vehicle: true };
}>;

export type Context = {
  user: Omit<UserWithRelations, "company" | "vehicle">;
  company: NonNullable<UserWithRelations["company"]>;
  vehicle: UserWithRelations["vehicle"];
};

export async function getContext(): Promise<Context> {
  try {
    const { sessions } = await clerkClient();
    const { userId, sessionId } = await auth();
    if (!userId) throw new Error("Unauthorized");

    const userFound = await prisma.user.findFirst({
      where: { externalId: userId },
      include: {
        vehicle: true,
        company: {
          include: {
            parentCompany: true,
          },
        },
      },
    });
    if (!userFound) {
      await sessions.revokeSession(sessionId);
      throw new Error("Unauthorized");
    }

    const { company, vehicle, ...user } = userFound;
    if (!company) {
      await sessions.revokeSession(sessionId);
      throw new Error("Unauthorized");
    }

    return { user, company, vehicle };
  } catch (error) {
    console.error("getContext error:", error);
    throw error;
  }
}
