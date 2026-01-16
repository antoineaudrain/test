import { v4 as uuidv4 } from "uuid";
import type {
  BaseParams,
  GeoPoint,
  MapboxSuggestedAddress,
  RetrieveFeature,
  RetrieveParams,
  SuggestParams,
} from "@/lib/mapbox/types";

const BASE_URL = "https://api.mapbox.com/search/searchbox/v1";

export class Mapbox {
  private static instance: Mapbox;
  private readonly accessToken: string;

  private constructor() {
    const token = process.env.NEXT_PUBLIC_MAPBOX_TOKEN;
    if (!token) throw new Error("Mapbox access token is required.");
    this.accessToken = token;
  }

  public static getInstance(): Mapbox {
    if (!Mapbox.instance) {
      Mapbox.instance = new Mapbox();
    }
    return Mapbox.instance;
  }

  async suggest(params: SuggestParams): Promise<MapboxSuggestedAddress[]> {
    const {
      q,
      sessionToken = uuidv4(),
      proximity,
      bbox,
      country,
      types,
      limit,
      language,
      autoComplete = true,
      poiCategory,
      poiCategoryExclusions,
      ...navigationParams
    } = params;

    const url = this.buildUrl(
      `${BASE_URL}/suggest`,
      {
        q,
        types: types?.join(","),
        limit,
        country,
        language,
        poi_category: poiCategory,
        poi_category_exclusions: poiCategoryExclusions,
        proximity: proximity && this.formatGeoPoint(proximity),
        bbox: bbox?.join(","),
      },
      sessionToken,
      navigationParams,
    );

    const data = await this.fetchJson(url);
    return data.suggestions ?? [];
  }

  async retrieve(params: RetrieveParams): Promise<RetrieveFeature | null> {
    const {
      id,
      sessionToken = uuidv4(),
      language = "en",
      ...navigationParams
    } = params;

    const url = this.buildUrl(
      `${BASE_URL}/retrieve/${id}`,
      { language },
      sessionToken,
      navigationParams,
    );

    const data = await this.fetchJson(url);
    const feature = data.features?.[0];
    if (!feature) return null;

    const { geometry, properties } = feature;
    const context = properties.context || {};

    return {
      latitude: geometry.coordinates[1],
      longitude: geometry.coordinates[0],
      address: properties.address,
      street: context.street?.name || context.address?.name,
      postcode: context.postcode?.name,
      city: context.place?.name,
      region: context.region?.name,
      country: context.country?.name,
    };
  }

  private buildUrl(
    baseUrl: string,
    params: Record<string, string | number | undefined | null>,
    sessionToken: string,
    nav: BaseParams,
  ): string {
    const url = new URL(baseUrl);
    const sp = url.searchParams;

    sp.set("access_token", encodeURIComponent(this.accessToken));
    sp.set("session_token", encodeURIComponent(sessionToken));

    Object.entries(params).forEach(([key, value]) => {
      if (value !== undefined && value !== null) {
        sp.set(encodeURIComponent(key), encodeURIComponent(String(value)));
      }
    });

    if (nav.etaType === "navigation") {
      sp.set("eta_type", "navigation");
      if (nav.navigationProfile) {
        sp.set("navigation_profile", encodeURIComponent(nav.navigationProfile));
      }
      if (nav.origin) {
        sp.set("origin", encodeURIComponent(this.formatGeoPoint(nav.origin)));
      }
    }

    return url.toString();
  }

  private formatGeoPoint({ lng, lat }: GeoPoint): string {
    return `${lng},${lat}`;
  }

  private async fetchJson(url: string): Promise<any> {
    const res = await fetch(url);
    if (!res.ok) throw new Error(`Mapbox API error: ${res.statusText}`);
    return res.json();
  }
}

export const MapboxClient = Mapbox.getInstance();
