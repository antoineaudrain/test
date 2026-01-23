"use client";

import { zodResolver } from "@hookform/resolvers/zod";
import { Controller, useForm } from "react-hook-form";
import { EditAddressForm } from "@/features/addresses/components/EditAddressForm";
import { createEndClient } from "@/features/clients/actions/mutations/createEndClient";
import {
  type CreateEndClientFormInput,
  CreateEndClientFormSchema,
} from "@/features/clients/schemas/createEndClient";
import {
  Button,
  ErrorMessage,
  Field,
  FieldGroup,
  Fieldset,
  Input,
  Label,
  Legend,
} from "@/features/shared/components";

export function NewEndClientForm() {
  const {
    control,
    register,
    handleSubmit,
    clearErrors,
    formState: { errors, isSubmitting },
  } = useForm<CreateEndClientFormInput>({
    resolver: zodResolver(CreateEndClientFormSchema),
  });

  return (
    <form
      onSubmit={handleSubmit((input: CreateEndClientFormInput) =>
        createEndClient({ input }),
      )}
      className="space-y-8"
    >
      <Fieldset>
        <Legend>Informations Entreprise</Legend>
        <FieldGroup>
          <div className="grid grid-cols-1 gap-8 sm:grid-cols-2 sm:gap-4">
            <Field>
              <Label>Nom</Label>
              <Input
                {...register("name")}
                type="text"
                placeholder="Acme"
                disabled={isSubmitting}
                invalid={!!errors?.name}
              />
              {errors?.name && (
                <ErrorMessage>{errors.name.message}</ErrorMessage>
              )}
            </Field>
            <Field>
              <Label>Adresse</Label>
              <Controller
                name="address"
                control={control}
                render={({ field }) => (
                  <EditAddressForm
                    value={field.value}
                    onChange={field.onChange}
                    onErrorClear={() => clearErrors("address")}
                    disabled={isSubmitting}
                    placeholder="12 Rue du Lac, 75001 Paris"
                  />
                )}
              />
              {errors?.address && <ErrorMessage>Adresse invalide</ErrorMessage>}
            </Field>
          </div>
        </FieldGroup>
      </Fieldset>

      <div className="flex items-center justify-end gap-4">
        <Button type="submit">
          {isSubmitting ? "Ajout en cours..." : "Ajouter"}
        </Button>
      </div>
    </form>
  );
}
