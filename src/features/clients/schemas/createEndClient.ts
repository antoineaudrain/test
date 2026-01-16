import { z } from "zod";
import { UpdateAddressSchema } from "@/features/addresses/schemas/updateAddress";

export const CreateEndClientFormSchema = z.object({
  name: z.string().min(1, { message: "Le nom est requis" }),
  address: UpdateAddressSchema.required(),
});

export type CreateEndClientFormInput = z.infer<
  typeof CreateEndClientFormSchema
>;
