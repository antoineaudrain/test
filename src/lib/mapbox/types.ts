export type GeoPoint = { lat: number; lng: number };

export type MapboxPlaceContext = {
  country?: {
    name: string;
    country_code: string;
    country_code_alpha_3: string;
  };
  postcode?: {
    id: string;
    name: string;
  };
  place?: {
    id: string;
    name: string;
  };
  region?: {
    id: string;
    name: string;
  };
  address?: {
    name: string;
    address_number: string;
    street_name: string;
  };
  street?: {
    name: string;
  };
};

export type MapboxExternalIds = {
  dataplor?: string;
  [provider: string]: string | undefined;
};

export type MapboxSuggestedAddress = {
  name: string;
  mapbox_id: string;
  feature_type: string;
  address?: string;
  full_address: string;
  place_formatted: string;
  context: MapboxPlaceContext;
  language: string;
  maki?: string;
  poi_category?: string[];
  poi_category_ids?: string[];
  external_ids?: MapboxExternalIds;
  metadata?: Record<string, unknown>;
  distance?: number;
};

export type RetrieveFeature = {
  latitude: number;
  longitude: number;
  address: string;
  street: string;
  postcode: string;
  city: string;
  region: string;
  country: string;
};

export type BaseParams = {
  sessionToken?: string;
  language?: string;
  etaType?: "navigation";
  navigationProfile?: "driving" | "walking" | "cycling";
  origin?: GeoPoint;
};

export type MapboxPlaceType =
  | "country"
  | "region"
  | "postcode"
  | "district"
  | "place"
  | "city"
  | "locality"
  | "neighborhood"
  | "street"
  | "address"
  | "poi"
  | "category";

export type SuggestParams = BaseParams & {
  q: string;
  proximity?: GeoPoint;
  bbox?: [number, number, number, number];
  country?: string;
  types?: MapboxPlaceType[];
  limit?: number;
  autoComplete?: boolean;
  poiCategory?: string;
  poiCategoryExclusions?: string;
};

export type RetrieveParams = BaseParams & {
  id: string;
};
