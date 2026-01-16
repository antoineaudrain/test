import type { Prisma } from "@/generated/prisma";

export type Stop = Prisma.StopGetPayload<{}>;

export type StopIncludeOptions = Prisma.StopInclude;
export type StopWithRelations<T extends StopIncludeOptions> =
  Prisma.StopGetPayload<{ include: T }>;
