"use client";

import { zodResolver } from "@hookform/resolvers/zod";
import { Controller, useForm } from "react-hook-form";
import { EditAddressForm } from "@/features/addresses/components/EditAddressForm";
import { createCompany } from "@/features/clients/actions/mutations/createCompany";
import {
  CreateClientCompanyFormSchema,
  type CreateClientCompanyFormInput,
  type CreateCompanyFormInput,
  CreateCompanyFormSchema,
} from "@/features/clients/schemas/createCompany";
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

type CreateCompanyFormProps = {
  companyTypeLabel: string;
  requiresOwner: boolean;
};

export function CreateCompanyForm({
  companyTypeLabel,
  requiresOwner,
}: CreateCompanyFormProps) {
  const schema = requiresOwner
    ? CreateClientCompanyFormSchema
    : CreateCompanyFormSchema;

  const {
    control,
    register,
    handleSubmit,
    formState: { errors, isSubmitting },
  } = useForm<CreateClientCompanyFormInput>({
    resolver: zodResolver(schema) as any,
  });

  const onSubmit = async (input: CreateClientCompanyFormInput) => {
    try {
      await createCompany({ input });
    } catch (error) {
      console.error("Failed to new company:", error);
    }
  };

  return (
    <form onSubmit={handleSubmit(onSubmit)} className="space-y-8">
      <Fieldset>
        <Legend>Informations {companyTypeLabel}</Legend>
        <FieldGroup>
          <div className="grid grid-cols-1 gap-8 sm:grid-cols-2 sm:gap-4">
            <Field>
              <Label>Nom</Label>
              <Input
                {...register("name")}
                type="text"
                placeholder="Nom de l'entreprise"
                disabled={isSubmitting}
                invalid={!!errors?.name}
                autoComplete="organization"
                maxLength={100}
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

      {requiresOwner && (
        <>
          <Fieldset>
            <Legend>Propriétaire du Compte</Legend>
            <FieldGroup>
              <div className="grid grid-cols-1 gap-8 sm:grid-cols-2 sm:gap-4">
                <Field>
                  <Label>Email</Label>
                  <Input
                    {...register("ownerEmail")}
                    type="email"
                    placeholder="email@exemple.com"
                    disabled={isSubmitting}
                    invalid={!!errors?.ownerEmail}
                    autoComplete="email"
                  />
                  {errors?.ownerEmail && (
                    <ErrorMessage>{errors.ownerEmail.message}</ErrorMessage>
                  )}
                </Field>
                <div />
                <Field>
                  <Label>Prénom</Label>
                  <Input
                    {...register("ownerFirstName")}
                    type="text"
                    placeholder="Jean"
                    disabled={isSubmitting}
                    invalid={!!errors?.ownerFirstName}
                    autoComplete="given-name"
                    maxLength={50}
                  />
                  {errors?.ownerFirstName && (
                    <ErrorMessage>{errors.ownerFirstName.message}</ErrorMessage>
                  )}
                </Field>
                <Field>
                  <Label>Nom</Label>
                  <Input
                    {...register("ownerLastName")}
                    type="text"
                    placeholder="Dupont"
                    disabled={isSubmitting}
                    invalid={!!errors?.ownerLastName}
                    autoComplete="family-name"
                    maxLength={50}
                  />
                  {errors?.ownerLastName && (
                    <ErrorMessage>{errors.ownerLastName.message}</ErrorMessage>
                  )}
                </Field>
              </div>
            </FieldGroup>
          </Fieldset>

          <Fieldset>
            <Legend>Paramètres de Demande</Legend>
            <FieldGroup>
              <Field>
                <Label>Heure Limite de Modification</Label>
                <Input
                  {...register("cutoffTime")}
                  type="time"
                  placeholder="16:00"
                  disabled={isSubmitting}
                  invalid={!!errors?.cutoffTime}
                />
                {errors?.cutoffTime && (
                  <ErrorMessage>{errors.cutoffTime.message}</ErrorMessage>
                )}
                <p className="mt-1 text-sm text-zinc-500 dark:text-zinc-400">
                  Heure limite avant laquelle le client peut modifier ses
                  demandes de livraison (optionnel)
                </p>
              </Field>
            </FieldGroup>
          </Fieldset>
        </>
      )}

      <div className="flex items-center justify-end gap-4">
        <Button type="submit" disabled={isSubmitting}>
          {isSubmitting ? "Création en cours..." : "Créer"}
        </Button>
      </div>
    </form>
  );
}
