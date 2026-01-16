"use client";

import { zodResolver } from "@hookform/resolvers/zod";
import { useForm } from "react-hook-form";
import { updateEmployee } from "@/features/employees/actions/mutations/updateEmployee";
import {
  type UpdateEmployeeFormInput,
  UpdateEmployeeFormSchema,
} from "@/features/employees/schemas/updateEmployee";
import {
  Button,
  ErrorMessage,
  Field,
  FieldGroup,
  Fieldset,
  Input,
  Label,
} from "@/features/shared/components";

type UpdateEmployeeFormProps = {
  employeeId: string;
  defaultValues: Partial<UpdateEmployeeFormInput>;
};

export function EditEmployeeForm({
  employeeId,
  defaultValues = {},
}: UpdateEmployeeFormProps) {
  const {
    register,
    handleSubmit,
    formState: { errors, isDirty, isSubmitting },
  } = useForm<UpdateEmployeeFormInput>({
    resolver: zodResolver(UpdateEmployeeFormSchema),
    defaultValues,
  });

  return (
    <form
      onSubmit={handleSubmit((input: UpdateEmployeeFormInput) =>
        updateEmployee({ employeeId, input }),
      )}
      className="space-y-8"
    >
      <Fieldset>
        <FieldGroup>
          <Field>
            <Label>Email</Label>
            <Input
              {...register("email")}
              type="email"
              placeholder="john.doe@acme.co"
              disabled
              invalid={!!errors?.email}
            />
            {errors?.email && (
              <ErrorMessage>{errors.email.message}</ErrorMessage>
            )}
          </Field>

          <div className="grid grid-cols-1 gap-8 sm:grid-cols-2 sm:gap-4">
            <Field>
              <Label>Nom</Label>
              <Input
                {...register("lastName")}
                type="text"
                placeholder="Doe"
                disabled={isSubmitting}
                invalid={!!errors?.lastName}
              />
              {errors?.lastName && (
                <ErrorMessage>{errors.lastName.message}</ErrorMessage>
              )}
            </Field>

            <Field>
              <Label>Prénom</Label>
              <Input
                {...register("firstName")}
                type="text"
                placeholder="John"
                disabled={isSubmitting}
                invalid={!!errors?.firstName}
              />
              {errors?.firstName && (
                <ErrorMessage>{errors.firstName.message}</ErrorMessage>
              )}
            </Field>
          </div>
        </FieldGroup>
      </Fieldset>

      <div className="flex items-center justify-end gap-4">
        <Button type="submit" disabled={!isDirty}>
          {isSubmitting ? "Enregistrement en cours..." : "Enregistrer"}
        </Button>
      </div>
    </form>
  );
}
