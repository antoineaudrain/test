"use client";

import type { ComboboxProps } from "@headlessui/react";
import { Loader2, Search } from "lucide-react";
import { useCallback, useMemo, useState } from "react";
import { useAutocomplete } from "@/features/addresses/hooks/useAutocomplete";
import type { UpdateAddressInput } from "@/features/addresses/schemas/updateAddress";
import {
  Combobox,
  ComboboxDescription,
  ComboboxLabel,
  ComboboxOption,
  InputGroup,
} from "@/features/shared/components";
import { MapboxClient, type MapboxSuggestedAddress } from "@/lib/mapbox";

type EditAddressFormProps = {
  value?: UpdateAddressInput | null;
  onChange?: (value: UpdateAddressInput | null) => void;
  placeholder?: string;
  disabled?: boolean;
} & Omit<
  ComboboxProps<MapboxSuggestedAddress, false>,
  "as" | "multiple" | "children" | "value" | "onChange"
> & {
    anchor?: "top" | "bottom";
  };

export function EditAddressForm({
  value,
  onChange,
  placeholder,
  disabled,
}: EditAddressFormProps) {
  const [inputValue, setInputValue] = useState("");
  const { suggestions, isLoading } = useAutocomplete(inputValue);

  const initialOption = useMemo(
    () =>
      value
        ? {
            name: value.formattedAddress ?? `${value.address}, ${value.city}`,
            mapbox_id: value.externalId,
            feature_type: "address",
            address: value.address,
            full_address: value.formattedAddress,
            place_formatted: `${value.postalCode} ${value.city}, ${value.country}`,
            context: {
              country: {
                name: value.country,
                country_code: "",
                country_code_alpha_3: "",
              },
              postcode: {
                id: value.postalCode,
                name: value.postalCode,
              },
              place: {
                id: value.city,
                name: value.city,
              },
              region: {
                id: value.state,
                name: value.state,
              },
              address: {
                name: value.address,
                address_number: "",
                street_name: value.address,
              },
            },
            language: "fr",
            external_ids: {},
            metadata: {},
            distance: undefined,
          }
        : undefined,
    [value],
  );

  const displayValue = useCallback(
    (address: MapboxSuggestedAddress | null) =>
      address ? address.name : inputValue,
    [inputValue],
  );

  const fetchDetailedAddress = useCallback(
    async (
      address: MapboxSuggestedAddress,
    ): Promise<UpdateAddressInput | null> => {
      try {
        const addressWithCoords = await MapboxClient.retrieve({
          id: address.mapbox_id,
        });
        if (!addressWithCoords) {
          return null;
        }

        return {
          externalId: address.mapbox_id ?? "",
          address: address.address ?? "",
          city: address.context.place?.name ?? "",
          state: address.context.region?.name ?? "",
          postalCode: address.context.postcode?.name ?? "",
          country: address.context.country?.name ?? "",
          formattedAddress:
            address.name && address.place_formatted
              ? `${address.name}, ${address.place_formatted}`
              : "",
          latitude: addressWithCoords.latitude,
          longitude: addressWithCoords.longitude,
        } satisfies UpdateAddressInput;
      } catch (error) {
        console.error("Error fetching detailed address:", error);
        return null;
      }
    },
    [],
  );

  const handleSelectAddress = useCallback(
    async (address: MapboxSuggestedAddress | null): Promise<void> => {
      if (!address) {
        onChange?.(null);
        return;
      }

      const detailedAddress = await fetchDetailedAddress(address);
      onChange?.(detailedAddress);
    },
    [fetchDetailedAddress, onChange],
  );

  return (
    <InputGroup>
      {isLoading ? (
        <Loader2 data-slot="icon" className="size-5 animate-spin" />
      ) : (
        <Search data-slot="icon" className="size-5" />
      )}

      <Combobox<MapboxSuggestedAddress>
        value={initialOption}
        onChange={handleSelectAddress}
        displayValue={displayValue}
        onInputChange={setInputValue}
        options={suggestions}
        placeholder={placeholder}
        disabled={disabled}
      >
        {(address) => (
          <ComboboxOption<MapboxSuggestedAddress>
            key={address.mapbox_id}
            value={address}
          >
            <ComboboxLabel>{address.name}</ComboboxLabel>
            <ComboboxDescription>{address.place_formatted}</ComboboxDescription>
          </ComboboxOption>
        )}
      </Combobox>
    </InputGroup>
  );
}
