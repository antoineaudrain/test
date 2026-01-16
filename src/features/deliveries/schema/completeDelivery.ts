import { z } from "zod";

export const CompleteDeliveryFormSchema = z.object({
  driverNotes: z.string().optional(),
  finishedAt: z.date(),
});

export type CompleteDeliveryFormInput = z.infer<
  typeof CompleteDeliveryFormSchema
>;
