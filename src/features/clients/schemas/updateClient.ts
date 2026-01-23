import { z } from "zod";
import { UpdateAddressSchema } from "@/features/addresses/schemas/updateAddress";

export const UpdateClientFormSchema = z.object({
  name: z.string().min(1, { message: "Le nom est requis" }),
  address: UpdateAddressSchema,
  cutoffTime: z
    .string()
    .regex(/^([0-1][0-9]|2[0-3]):[0-5][0-9]$/, {
      message: "Format invalide (HH:mm)",
    })
    .optional()
    .nullable(),
});

export type UpdateClientFormInput = z.infer<typeof UpdateClientFormSchema>;
