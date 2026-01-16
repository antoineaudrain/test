"use client";

import { useCallback, useEffect, useState } from "react";
import { useDebounce } from "use-debounce";
import { MapboxClient, type MapboxSuggestedAddress } from "@/lib/mapbox";

export const useAutocomplete = (query: string) => {
  const [suggestions, setSuggestions] = useState<MapboxSuggestedAddress[]>([]);
  const [isLoading, setIsLoading] = useState(false);

  const [debouncedQuery] = useDebounce(query, 300);

  const fetchSuggestions = useCallback(
    async (searchQuery: string) => {
      if (!searchQuery.trim()) {
        return;
      }

      setIsLoading(true);
      MapboxClient.suggest({ q: debouncedQuery, limit: 6 })
        .then(setSuggestions)
        .catch((error) => {
          console.error("Autocomplete failed:", error);
          setSuggestions([]);
        })
        .finally(() => setIsLoading(false));
    },
    [debouncedQuery],
  );

  useEffect(() => {
    if (debouncedQuery.trim()) {
      fetchSuggestions(debouncedQuery);
    }
  }, [debouncedQuery, fetchSuggestions]);

  return { suggestions, isLoading };
};
