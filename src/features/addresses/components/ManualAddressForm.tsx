"use client";

import { useEffect, useRef, useState } from "react";
import type { UpdateAddressInput } from "@/features/addresses/schemas/updateAddress";
import {
  Button,
  Field,
  FieldGroup,
  Input,
  Label,
} from "@/features/shared/components";

type ManualAddressFormProps = {
  onChange: (address: UpdateAddressInput) => void;
  onCancel: () => void;
  disabled?: boolean;
  initialValue?: UpdateAddressInput | null;
};

export function ManualAddressForm({
  onChange,
  onCancel,
  disabled,
  initialValue,
}: ManualAddressFormProps) {
  const [formData, setFormData] = useState({
    address: initialValue?.address ?? "",
    postalCode: initialValue?.postalCode ?? "",
    city: initialValue?.city ?? "",
    state: initialValue?.state ?? "",
    country: initialValue?.country ?? "France",
  });

  // Store onChange in a ref to avoid infinite loops
  const onChangeRef = useRef(onChange);
  useEffect(() => {
    onChangeRef.current = onChange;
  }, [onChange]);

  // Update parent form whenever formData changes
  useEffect(() => {
    // Build formatted address string
    const formattedAddress = `${formData.address}, ${formData.postalCode} ${formData.city}, ${formData.country}`;

    const addressInput: UpdateAddressInput = {
      externalId: undefined, // No Mapbox ID for manual entries
      formattedAddress,
      address: formData.address,
      city: formData.city,
      state: formData.state,
      postalCode: formData.postalCode,
      country: formData.country,
      latitude: undefined, // No coordinates for manual entries
      longitude: undefined,
    };

    onChangeRef.current(addressInput);
  }, [formData]);

  return (
    <div className="space-y-4">
      <FieldGroup>
        <Field>
          <Input
            value={formData.address}
            onChange={(e) =>
              setFormData({ ...formData, address: e.target.value })
            }
            placeholder="12 Rue de la République"
            disabled={disabled}
            autoComplete="street-address"
          />
        </Field>

        <div className="grid grid-cols-2 gap-4">
          <Field>
            <Label>Code postal</Label>
            <Input
              value={formData.postalCode}
              onChange={(e) =>
                setFormData({ ...formData, postalCode: e.target.value })
              }
              placeholder="75001"
              disabled={disabled}
              autoComplete="postal-code"
              maxLength={12}
            />
          </Field>
          <Field>
            <Label>Ville</Label>
            <Input
              value={formData.city}
              onChange={(e) =>
                setFormData({ ...formData, city: e.target.value })
              }
              placeholder="Paris"
              disabled={disabled}
              autoComplete="address-level2"
            />
          </Field>
        </div>

        <Field>
          <Label>Région/Département</Label>
          <Input
            value={formData.state}
            onChange={(e) =>
              setFormData({ ...formData, state: e.target.value })
            }
            placeholder="Île-de-France"
            disabled={disabled}
          />
        </Field>

        <Field>
          <Label>Pays</Label>
          <Input
            value={formData.country}
            onChange={(e) =>
              setFormData({ ...formData, country: e.target.value })
            }
            placeholder="France"
            disabled={disabled}
            autoComplete="country-name"
          />
        </Field>
      </FieldGroup>

      <div className="flex items-center justify-between gap-3 pt-2">
        <p className="text-sm text-amber-600 dark:text-amber-500">
          ⚠️ Adresse sans coordonnées GPS
        </p>
        <Button
          type="button"
          onClick={onCancel}
          disabled={disabled}
          outline
        >
          Annuler
        </Button>
      </div>
    </div>
  );
}
