import { z } from "zod";

const UpdateDeliveryStopFormSchema = z.object({
  companyId: z.string(),
  selected: z.boolean(),
  name: z.string(),
  sequence: z.number().int().nonnegative(),
  type: z.enum(["PICKUP", "DROPOFF", "BOTH"]).nullable(),
  notes: z.string().optional(),
});

export type UpdateDeliveryStopFormInput = z.infer<
  typeof UpdateDeliveryStopFormSchema
>;

export const UpdateDeliveryFormSchema = z.object({
  notes: z.string().optional(),
  stops: z
    .array(UpdateDeliveryStopFormSchema)
    .refine((stops) => stops.some((stop) => stop.selected), {
      message: "Au moins un arrêt doit être sélectionné",
    }),
});

export type UpdateDeliveryFormInput = z.infer<typeof UpdateDeliveryFormSchema>;
