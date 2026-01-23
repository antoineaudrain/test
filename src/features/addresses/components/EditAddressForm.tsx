"use client";

import type { ComboboxProps } from "@headlessui/react";
import { Edit3, Loader2, Search } from "lucide-react";
import { useCallback, useMemo, useState } from "react";
import { useAutocomplete } from "@/features/addresses/hooks/useAutocomplete";
import { ManualAddressForm } from "@/features/addresses/components/ManualAddressForm";
import type { UpdateAddressInput } from "@/features/addresses/schemas/updateAddress";
import {
  Button,
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
  onErrorClear?: () => void; // Callback to clear validation errors
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
  onErrorClear,
  placeholder,
  disabled,
}: EditAddressFormProps) {
  const [inputValue, setInputValue] = useState("");
  const [showManualEntry, setShowManualEntry] = useState(false);
  const [fetchError, setFetchError] = useState<string | null>(null);
  const { suggestions, isLoading } = useAutocomplete(inputValue);

  // Determine if we should show the "no results" state
  const hasSearched = inputValue.length > 0;
  const hasNoResults = hasSearched && !isLoading && suggestions.length === 0;

  const initialOption = useMemo(
    () =>
      value
        ? {
            name: value.formattedAddress ?? `${value.address}, ${value.city}`,
            mapbox_id: value.externalId ?? "",
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
      setFetchError(null); // Clear any previous errors

      try {
        const addressWithCoords = await MapboxClient.retrieve({
          id: address.mapbox_id,
        });

        // Build address object with available data
        const addressInput: UpdateAddressInput = {
          externalId: address.mapbox_id ?? undefined,
          address: address.address ?? "",
          city: address.context.place?.name ?? "",
          state: address.context.region?.name ?? "",
          postalCode: address.context.postcode?.name ?? "",
          country: address.context.country?.name ?? "",
          formattedAddress:
            address.name && address.place_formatted
              ? `${address.name}, ${address.place_formatted}`
              : "",
          // Coordinates are optional - may be undefined if Mapbox retrieve fails
          latitude: addressWithCoords?.latitude,
          longitude: addressWithCoords?.longitude,
        };

        // Validate that we have at least the required text fields
        if (
          !addressInput.address ||
          !addressInput.city ||
          !addressInput.postalCode
        ) {
          console.error("Mapbox returned incomplete address data:", address);
          setFetchError(
            "Les données de l'adresse sont incomplètes. Veuillez saisir manuellement.",
          );
          return null;
        }

        return addressInput;
      } catch (error) {
        console.error("Error fetching detailed address:", error);
        setFetchError(
          "Erreur lors de la récupération de l'adresse. Veuillez réessayer ou saisir manuellement.",
        );
        return null;
      }
    },
    [],
  );

  const handleSelectAddress = useCallback(
    async (address: MapboxSuggestedAddress | null): Promise<void> => {
      if (!address) {
        onChange?.(null);
        setFetchError(null);
        return;
      }

      const detailedAddress = await fetchDetailedAddress(address);
      onChange?.(detailedAddress);
    },
    [fetchDetailedAddress, onChange],
  );

  const handleManualChange = useCallback(
    (address: UpdateAddressInput) => {
      onChange?.(address);
      onErrorClear?.(); // Clear form validation errors
    },
    [onChange, onErrorClear],
  );

  const handleManualCancel = useCallback(() => {
    setShowManualEntry(false);
    setFetchError(null); // Clear any fetch errors
  }, []);

  const handleOpenManualEntry = useCallback(() => {
    setShowManualEntry(true);
    setFetchError(null); // Clear fetch errors when opening manual mode
    onErrorClear?.(); // Clear form validation errors when opening manual mode
  }, [onErrorClear]);

  // Show manual entry form when requested
  if (showManualEntry) {
    return (
      <div className="space-y-3">
        <ManualAddressForm
          onChange={handleManualChange}
          onCancel={handleManualCancel}
          disabled={disabled}
          initialValue={value}
        />
      </div>
    );
  }

  // Show autocomplete with manual entry option
  return (
    <div className="space-y-2">
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
              <ComboboxDescription>
                {address.place_formatted}
              </ComboboxDescription>
            </ComboboxOption>
          )}
        </Combobox>
      </InputGroup>

      {/* Error message from fetch */}
      {fetchError && (
        <div className="flex items-start gap-2 text-sm text-red-600 dark:text-red-400 bg-red-50 dark:bg-red-950/20 px-3 py-2 rounded-md border border-red-200 dark:border-red-800">
          <span className="text-base leading-none mt-0.5">⚠️</span>
          <span>{fetchError}</span>
        </div>
      )}

      {/* No results message */}
      {hasNoResults && !fetchError && (
        <div className="flex items-start gap-2 text-sm text-amber-600 dark:text-amber-500 bg-amber-50 dark:bg-amber-950/20 px-3 py-2 rounded-md border border-amber-200 dark:border-amber-800">
          <span className="text-base leading-none mt-0.5">🔍</span>
          <span>
            Aucune adresse trouvée pour "{inputValue}". Essayez de modifier
            votre recherche ou saisissez l'adresse manuellement.
          </span>
        </div>
      )}

      {/* Manual entry button - more prominent when there's an issue */}
      {(hasNoResults || fetchError) ? (
        <Button
          type="button"
          onClick={handleOpenManualEntry}
          disabled={disabled}
          className="w-full"
        >
          <Edit3 className="size-4" />
          Saisir l'adresse manuellement
        </Button>
      ) : (
        <button
          type="button"
          onClick={handleOpenManualEntry}
          disabled={disabled}
          className="inline-flex items-center gap-1.5 text-sm text-zinc-600 hover:text-zinc-900 dark:text-zinc-400 dark:hover:text-zinc-200 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
        >
          <Edit3 className="size-3.5" />
          Saisir manuellement
        </button>
      )}
    </div>
  );
}
