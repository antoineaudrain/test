import { z } from "zod";
import { StopType } from "@/generated/prisma";

// Stop schema for delivery request
export const DeliveryRequestStopSchema = z.object({
  id: z.string().optional(), // For updates
  sequence: z.number().int().positive(),
  type: z.nativeEnum(StopType),
  endClientId: z.string().min(1, "End client is required"),
  addressId: z.string().min(1, "Address is required"),
  notes: z.string().optional(),
});

export type DeliveryRequestStopInput = z.infer<
  typeof DeliveryRequestStopSchema
>;

// Create delivery request schema
export const CreateDeliveryRequestSchema = z.object({
  date: z
    .string()
    .regex(/^\d{4}-\d{2}-\d{2}$/, "Invalid date format (YYYY-MM-DD)"),
  notes: z.string().optional(),
  stops: z
    .array(DeliveryRequestStopSchema)
    .min(1, "At least one stop is required")
    .refine(
      (stops) => {
        const sequences = stops.map((s) => s.sequence);
        return sequences.length === new Set(sequences).size;
      },
      { message: "Stop sequences must be unique" },
    ),
});

export type CreateDeliveryRequestInput = z.infer<
  typeof CreateDeliveryRequestSchema
>;

// Update delivery request schema
export const UpdateDeliveryRequestSchema = z.object({
  requestId: z.string().min(1, "Request ID is required"),
  notes: z.string().optional(),
  stops: z
    .array(DeliveryRequestStopSchema)
    .min(1, "At least one stop is required")
    .refine(
      (stops) => {
        const sequences = stops.map((s) => s.sequence);
        return sequences.length === new Set(sequences).size;
      },
      { message: "Stop sequences must be unique" },
    )
    .optional(),
});

export type UpdateDeliveryRequestInput = z.infer<
  typeof UpdateDeliveryRequestSchema
>;

// Cancel delivery request schema
export const CancelDeliveryRequestSchema = z.object({
  requestId: z.string().min(1, "Request ID is required"),
});

export type CancelDeliveryRequestInput = z.infer<
  typeof CancelDeliveryRequestSchema
>;
