import { z } from "zod";

export const UpdateEmployeeFormSchema = z.object({
  email: z.email().min(1, { message: "L'email est requis" }),
  firstName: z.string().min(1, { message: "Le prénom est requis" }),
  lastName: z.string().min(1, { message: "Le nom est requis" }),
});

export type UpdateEmployeeFormInput = z.infer<typeof UpdateEmployeeFormSchema>;
