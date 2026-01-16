import { z } from "zod";
import { isPast } from "@/features/shared/helper/time";
import { Time } from "@/lib/time";

const CreateDeliveryStopFormSchema = z
  .object({
    companyId: z.string(),
    selected: z.boolean(),
    name: z.string(),
    sequence: z.number().int().nonnegative(),
    type: z.enum(["PICKUP", "DROPOFF", "BOTH"]).nullable(),
    notes: z.string().optional(),
  })
  .refine((stop) => !(stop.selected && stop.type === null), {
    message: "Le type requis",
    path: ["type"],
  });

export type CreateDeliveryStopFormInput = z.infer<
  typeof CreateDeliveryStopFormSchema
>;

export const CreateDeliveryFormSchema = z.object({
  date: z.string().nonempty("La date est requise"),
  notes: z.string().optional(),
  stops: z
    .array(CreateDeliveryStopFormSchema)
    .min(1, "Au moins un arrêt doit être sélectionné")
    .refine((stops) => stops.some((stop) => stop.selected), {
      message: "Au moins un arrêt doit être sélectionné",
    }),
});

export type CreateDeliveryFormInput = z.infer<typeof CreateDeliveryFormSchema>;

export const createDeliveryFormSchemaWithExistingDates = (
  existingDeliveryDates: Date[],
) =>
  CreateDeliveryFormSchema.superRefine((data, ctx) => {
    if (isPast(data.date)) {
      ctx.addIssue({
        path: ["date"],
        code: z.ZodIssueCode.custom,
        message: "La date ne peut pas être dans le passé",
      });
    }

    const formattedExisting = existingDeliveryDates.map((d) =>
      Time(d).format("YYYY-MM-DD"),
    );

    if (formattedExisting.includes(Time(data.date).format("YYYY-MM-DD"))) {
      ctx.addIssue({
        path: ["date"],
        code: z.ZodIssueCode.custom,
        message: "Une livraison existe déjà pour cette date",
      });
    }
  });
