"use client";

import { zodResolver } from "@hookform/resolvers/zod";
import { useForm } from "react-hook-form";
import { completeDelivery } from "@/features/deliveries/actions/mutations/completeDelivery";
import {
  type CompleteDeliveryFormInput,
  CompleteDeliveryFormSchema,
} from "@/features/deliveries/schema/completeDelivery";
import {
  Button,
  ErrorMessage,
  Field,
  FieldGroup,
  Fieldset,
  Label,
  Textarea,
} from "@/features/shared/components";

type CompletedDeliveryFormProps = {
  deliveryId: string;
  finishedAt: Date;
};

export function CompletedDeliveryForm({
  deliveryId,
  finishedAt,
}: CompletedDeliveryFormProps) {
  const {
    watch,
    register,
    handleSubmit,
    formState: { errors, isDirty, isSubmitting },
  } = useForm<CompleteDeliveryFormInput>({
    resolver: zodResolver(CompleteDeliveryFormSchema),
    defaultValues: {
      finishedAt,
    },
  });

  return (
    <form
      onSubmit={handleSubmit((input) =>
        completeDelivery({ deliveryId, input }),
      )}
      className="space-y-8"
    >
      <Fieldset>
        <FieldGroup>
          <Field>
            <Label>Notes</Label>
            <Textarea
              {...register("driverNotes")}
              rows={3}
              placeholder="Ajouter une remarque (ex: colis manquant)..."
            />
            {errors?.driverNotes && (
              <ErrorMessage>{errors.driverNotes.message}</ErrorMessage>
            )}
          </Field>
        </FieldGroup>
      </Fieldset>

      <div className="flex items-center justify-end gap-4">
        <Button type="submit" disabled={!isDirty}>
          {isSubmitting ? "Confirmation en cours..." : "Confirmer"}
        </Button>
      </div>
    </form>
  );
}
