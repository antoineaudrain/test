import type { Prisma } from "@/generated/prisma";

// DeliveryRequest types
export type DeliveryRequest = Prisma.DeliveryRequestGetPayload<
  Record<string, never>
>;

export type DeliveryRequestIncludeOptions = Prisma.DeliveryRequestInclude;

export type DeliveryRequestWithRelations<
  T extends DeliveryRequestIncludeOptions,
> = Prisma.DeliveryRequestGetPayload<{ include: T }>;

// DeliveryRequestStop types
export type DeliveryRequestStop = Prisma.DeliveryRequestStopGetPayload<
  Record<string, never>
>;

export type DeliveryRequestStopIncludeOptions =
  Prisma.DeliveryRequestStopInclude;

export type DeliveryRequestStopWithRelations<
  T extends DeliveryRequestStopIncludeOptions,
> = Prisma.DeliveryRequestStopGetPayload<{ include: T }>;

// ClientSettings types
export type ClientSettings = Prisma.ClientSettingsGetPayload<
  Record<string, never>
>;

export type ClientSettingsIncludeOptions = Prisma.ClientSettingsInclude;

export type ClientSettingsWithRelations<
  T extends ClientSettingsIncludeOptions,
> = Prisma.ClientSettingsGetPayload<{ include: T }>;

// Commonly used combinations
export type DeliveryRequestWithStops = DeliveryRequestWithRelations<{
  stops: {
    include: {
      address: true;
      endClientCompany: true;
      deliveryStop: {
        include: {
          delivery: true;
        };
      };
    };
  };
  deliveryCompany: true;
  clientCompany: true;
}>;

export type DeliveryRequestStopWithDetails = DeliveryRequestStopWithRelations<{
  address: true;
  endClientCompany: true;
  deliveryStop: {
    include: {
      delivery: true;
    };
  };
}>;
