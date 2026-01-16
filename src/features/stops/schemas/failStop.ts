import { z } from "zod";

export const FailStopSchema = z.object({
  driverNotes: z.string().min(1, "Raison de l'abandon requis"),
  imageUrl: z.string().optional(),
});

export type FailStopInput = z.infer<typeof FailStopSchema>;
