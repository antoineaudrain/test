import { z } from "zod";
import { UpdateAddressSchema } from "@/features/addresses/schemas/updateAddress";

export const CreateCompanyFormSchema = z.object({
  name: z
    .string()
    .min(1, { message: "Le nom est requis" })
    .max(100, { message: "Le nom est trop long" })
    .trim(),
  address: UpdateAddressSchema.required(),
  ownerEmail: z
    .string()
    .email({ message: "Email invalide" })
    .min(1, { message: "L'email est requis" })
    .trim()
    .toLowerCase()
    .optional(),
  ownerFirstName: z
    .string()
    .min(1, { message: "Le prénom est requis" })
    .max(50, { message: "Le prénom est trop long" })
    .trim()
    .optional(),
  ownerLastName: z
    .string()
    .min(1, { message: "Le nom est requis" })
    .max(50, { message: "Le nom est trop long" })
    .trim()
    .optional(),
});

export const CreateClientCompanyFormSchema = CreateCompanyFormSchema.extend({
  ownerEmail: z
    .string()
    .email({ message: "Email invalide" })
    .min(1, { message: "L'email est requis" })
    .trim()
    .toLowerCase(),
  ownerFirstName: z
    .string()
    .min(1, { message: "Le prénom est requis" })
    .max(50, { message: "Le prénom est trop long" })
    .trim(),
  ownerLastName: z
    .string()
    .min(1, { message: "Le nom est requis" })
    .max(50, { message: "Le nom est trop long" })
    .trim(),
  cutoffTime: z
    .string()
    .regex(/^([0-1][0-9]|2[0-3]):[0-5][0-9]$/, {
      message: "Format invalide (HH:mm)",
    })
    .optional()
    .nullable(),
});

export type CreateCompanyFormInput = z.infer<typeof CreateCompanyFormSchema>;
export type CreateClientCompanyFormInput = z.infer<
  typeof CreateClientCompanyFormSchema
>;
