import type { Prisma } from "@/generated/prisma";

export type Delivery = Prisma.DeliveryGetPayload<{}>;

export type DeliveryIncludeOptions = Prisma.DeliveryInclude;
export type DeliveryWithRelations<T extends DeliveryIncludeOptions> =
  Prisma.DeliveryGetPayload<{ include: T }>;
