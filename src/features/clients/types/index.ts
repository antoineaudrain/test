import type { Prisma } from "@/generated/prisma";

export type Client = Prisma.CompanyGetPayload<Record<string, never>>;

export type ClientIncludeOptions = Prisma.CompanyInclude;
export type ClientWithRelations<T extends ClientIncludeOptions> =
  Prisma.CompanyGetPayload<{ include: T }>;
