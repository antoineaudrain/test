import { z } from "zod";

// Schema for a single delivery to be saved
export const DeliveryToSaveSchema = z.object({
  id: z.string().optional(), // If exists, update; otherwise new
  label: z.string().min(1, "Label is required"),
  driverId: z.string().min(1, "Driver is required"),
  vehicleId: z.string().min(1, "Vehicle is required"),
  requestStopIds: z.array(z.string()).min(1, "At least one stop is required"),
});

export type DeliveryToSave = z.infer<typeof DeliveryToSaveSchema>;

// Schema for saving deliveries
export const SaveDeliveriesSchema = z.object({
  date: z
    .string()
    .regex(/^\d{4}-\d{2}-\d{2}$/, "Invalid date format (YYYY-MM-DD)"),
  deliveries: z.array(DeliveryToSaveSchema),
  deletedDeliveryIds: z.array(z.string()).optional(),
});

export type SaveDeliveriesInput = z.infer<typeof SaveDeliveriesSchema>;

// Schema for client settings
export const UpdateClientSettingsSchema = z.object({
  clientCompanyId: z.string().min(1, "Client company ID is required"),
  cutoffTime: z
    .string()
    .regex(/^([0-1][0-9]|2[0-3]):[0-5][0-9]$/, "Invalid time format (HH:mm)")
    .nullable()
    .optional(),
});

export type UpdateClientSettingsInput = z.infer<
  typeof UpdateClientSettingsSchema
>;

// Schema for filters on past deliveries
export const PastDeliveriesFiltersSchema = z.object({
  dateFrom: z
    .string()
    .regex(/^\d{4}-\d{2}-\d{2}$/)
    .optional(),
  dateTo: z
    .string()
    .regex(/^\d{4}-\d{2}-\d{2}$/)
    .optional(),
  driverId: z.string().optional(),
  vehicleId: z.string().optional(),
  status: z.string().optional(),
  page: z.number().int().positive().default(1),
  pageSize: z.number().int().positive().default(20),
});

export type PastDeliveriesFilters = z.infer<typeof PastDeliveriesFiltersSchema>;
