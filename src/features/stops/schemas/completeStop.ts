import { z } from "zod";

export const CompleteStopSchema = z.object({
  driverNotes: z.string().optional(),
  imageUrl: z.string().optional(),
});

export type CompleteStopInput = z.infer<typeof CompleteStopSchema>;
