"use client";

import { zodResolver } from "@hookform/resolvers/zod";
import { Controller, useForm } from "react-hook-form";
import { EditAddressForm } from "@/features/addresses/components/EditAddressForm";
import { updateClient } from "@/features/clients/actions/mutations/updateClient";
import {
  type UpdateClientFormInput,
  UpdateClientFormSchema,
} from "@/features/clients/schemas/updateClient";
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
import { CompanyType } from "@/generated/prisma";

type UpdateClientFormProps = {
  clientId: string;
  clientType: CompanyType;
  defaultValues: Partial<UpdateClientFormInput>;
  disabled?: boolean;
};

export function UpdateClientForm({
  clientId,
  clientType,
  defaultValues = {},
  disabled = false,
}: UpdateClientFormProps) {
  const {
    control,
    register,
    handleSubmit,
    clearErrors,
    formState: { errors, isSubmitting },
  } = useForm<UpdateClientFormInput>({
    resolver: zodResolver(UpdateClientFormSchema),
    defaultValues,
    disabled,
  });

  const isClientCompany = clientType === CompanyType.CLIENT;

  return (
    <form
      onSubmit={handleSubmit((input: UpdateClientFormInput) =>
        updateClient({ clientId, input }),
      )}
      className="space-y-8"
    >
      <Fieldset>
        <FieldGroup>
          <div className="grid grid-cols-1 gap-8 sm:grid-cols-2 sm:gap-4">
            <Field>
              <Label>Nom</Label>
              <Input
                {...register("name")}
                type="text"
                placeholder="Acme"
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
                    placeholder="12 Rue du Lac, 75001 Paris"
                  />
                )}
              />
              {errors?.address && <ErrorMessage>Adresse invalide</ErrorMessage>}
            </Field>
          </div>
        </FieldGroup>
      </Fieldset>

      {isClientCompany && (
        <Fieldset>
          <Legend>Paramètres de Demande</Legend>
          <FieldGroup>
            <Field>
              <Label>Heure Limite de Modification</Label>
              <Input
                {...register("cutoffTime")}
                type="time"
                placeholder="16:00"
                invalid={!!errors?.cutoffTime}
              />
              {errors?.cutoffTime && (
                <ErrorMessage>{errors.cutoffTime.message}</ErrorMessage>
              )}
              <p className="mt-1 text-sm text-zinc-500 dark:text-zinc-400">
                Heure limite avant laquelle le client peut modifier ses demandes
                de livraison (optionnel)
              </p>
            </Field>
          </FieldGroup>
        </Fieldset>
      )}

      {!disabled && (
        <div className="flex items-center justify-end gap-4">
          <Button type="submit">
            {isSubmitting ? "Enregistrement en cours..." : "Enregistrer"}
          </Button>
        </div>
      )}
    </form>
  );
}
