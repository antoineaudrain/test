"use client";

import { type ChangeEvent, useMemo, useTransition } from "react";
import { assignVehicle } from "@/features/employees/actions/mutations/assignVehicle";
import { unassignVehicle } from "@/features/employees/actions/mutations/unassignVehicle";
import {
  Button,
  Field,
  FieldGroup,
  Fieldset,
  Label,
  Select,
} from "@/features/shared/components";
import type { Prisma } from "@/generated/prisma";

type Vehicle = Prisma.VehicleGetPayload<{
  include: { drivers: true };
}>;

type ManageEmployeeVehicleFormProps = {
  employeeId: string;
  vehicles: Vehicle[];
  vehicleId?: string;
};

export function ManageEmployeeVehicleForm({
  employeeId,
  vehicleId,
  vehicles,
}: ManageEmployeeVehicleFormProps) {
  const [isPending, startTransition] = useTransition();

  const options = useMemo(
    () =>
      vehicles.map((vehicle) => {
        const driver = vehicle.drivers?.[0];
        return {
          disabled: Boolean(driver) || vehicle.id === vehicleId,
          value: vehicle.id,
          label: driver
            ? `${vehicle.plate} (${driver.lastName} ${driver.firstName})`
            : vehicle.plate,
        };
      }),
    [vehicles, vehicleId],
  );

  const handleVehicleAssignation = (event: ChangeEvent<HTMLSelectElement>) => {
    startTransition(() =>
      assignVehicle({ employeeId, vehicleId: event.target.value }),
    );
  };

  const handleVehicleUnassignation = () => {
    startTransition(() => unassignVehicle({ employeeId }));
  };

  return (
    <Fieldset>
      <FieldGroup>
        <div className="grid grid-cols-1 gap-8 sm:grid-cols-2 sm:gap-4">
          <Field>
            <Label>Véhicule associé</Label>
            <Select
              value={vehicleId ?? ""}
              onChange={handleVehicleAssignation}
              disabled={isPending}
            >
              <option value="" disabled>
                Choisir un véhicule...
              </option>
              {options.map((option) => (
                <option
                  key={option.value}
                  value={option.value}
                  disabled={option.disabled}
                >
                  {option.label}
                </option>
              ))}
            </Select>
          </Field>

          <div className="flex flex-row items-end">
            <Button
              color="red"
              onClick={handleVehicleUnassignation}
              loading={isPending}
              disabled={!vehicleId || isPending}
            >
              Retirer
            </Button>
          </div>
        </div>
      </FieldGroup>
    </Fieldset>
  );
}
