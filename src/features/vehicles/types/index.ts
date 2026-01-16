import type { Prisma } from "@/generated/prisma";

export type Vehicle = Prisma.VehicleGetPayload<{}>;

export type VehicleIncludeOptions = Prisma.VehicleInclude;
export type VehicleWithRelations<T extends VehicleIncludeOptions> =
  Prisma.VehicleGetPayload<{ include: T }>;
