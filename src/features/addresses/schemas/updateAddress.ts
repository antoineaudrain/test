import { z } from "zod";

export const UpdateAddressSchema = z.object({
  externalId: z.string().min(1, { message: "L’adresse est obligatoire." }),
  formattedAddress: z
    .string()
    .min(1, { message: "L’adresse est obligatoire." }),
  address: z.string().min(1, { message: "L’adresse est obligatoire." }),
  city: z.string().min(1, { message: "La ville est obligatoire." }),
  state: z
    .string()
    .min(1, { message: "La région/département est obligatoire." }),
  postalCode: z
    .string()
    .min(3, { message: "Le code postal est trop court." })
    .max(12, { message: "Le code postal est trop long." })
    .regex(/^[A-Za-z0-9\s-]+$/, { message: "Format du code postal invalide." }),
  country: z
    .string()
    .min(2, { message: "Le pays est obligatoire." })
    .max(56, { message: "Le nom du pays est trop long." }),
  latitude: z
    .number()
    .min(-90, { message: "La latitude doit être comprise entre -90 et 90." })
    .max(90, { message: "La latitude doit être comprise entre -90 et 90." }),
  longitude: z
    .number()
    .min(-180, {
      message: "La longitude doit être comprise entre -180 et 180.",
    })
    .max(180, {
      message: "La longitude doit être comprise entre -180 et 180.",
    }),
});

export type UpdateAddressInput = z.infer<typeof UpdateAddressSchema>;
