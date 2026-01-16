import { z } from "zod";

export const SendContactEmailFormSchema = z.object({
  email: z
    .email({ message: "Adresse email invalide" })
    .min(1, "Email requis")
    .max(254, "Email trop long")
    .toLowerCase(),
  companyName: z
    .string()
    .min(1, "Nom d'entreprise requis")
    .max(50, "Nom d'entreprise trop long")
    .regex(/^[a-zA-ZÀ-ÿ\s'-]+$/, "Nom d'entreprise invalide"),
  message: z
    .string()
    .min(10, "Message trop court (minimum 10 caractères)")
    .max(2000, "Message trop long (maximum 2000 caractères)")
    .trim(),
});

export type SendContactEmailFormInput = z.infer<
  typeof SendContactEmailFormSchema
>;
