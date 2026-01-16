"use client";

import { PackageIcon } from "lucide-react";
import { useCallback, useRef } from "react";
import MapGL, {
  type MapRef,
  Marker,
  NavigationControl,
} from "react-map-gl/mapbox";

import "mapbox-gl/dist/mapbox-gl.css";
import mapboxgl from "mapbox-gl";

type MapMarker = {
  longitude: number;
  latitude: number;
};

type MapProps = {
  markers: MapMarker[];
};

export function DeliveryMap({ markers }: MapProps) {
  const mapRef = useRef<MapRef | null>(null);

  const fitBoundsToMarkers = useCallback(() => {
    const map = mapRef.current;
    if (!map || !markers.length) return;

    const bounds = new mapboxgl.LngLatBounds();
    markers.forEach((marker) => {
      bounds.extend([marker.longitude, marker.latitude]);
    });

    map.fitBounds(bounds, {
      padding: 60,
      duration: 800,
      maxZoom: 15,
    });
  }, [markers]);

  return (
    <MapGL
      ref={mapRef}
      onLoad={fitBoundsToMarkers}
      initialViewState={{
        longitude: markers[0]?.longitude || 0,
        latitude: markers[0]?.latitude || 0,
        zoom: 12,
      }}
      boxZoom={false}
      doubleClickZoom={false}
      dragRotate={false}
      dragPan={false}
      keyboard={false}
      scrollZoom={false}
      touchPitch={false}
      touchZoomRotate={false}
      mapboxAccessToken={process.env.NEXT_PUBLIC_MAPBOX_TOKEN}
      mapStyle={process.env.NEXT_PUBLIC_MAPBOX_STYLE_URL}
      style={{ width: "100%", height: "100%" }}
    >
      <NavigationControl />

      {markers.map(({ longitude, latitude }) => (
        <Marker
          key={`${longitude}-${latitude}`}
          longitude={longitude}
          latitude={latitude}
          anchor="bottom"
        >
          <div className="relative w-12 h-12 transform scale-100 origin-bottom transition-transform duration-150 ease-out bottom-[2px]">
            <div className="absolute bg-blue-500 bottom-[-2px] left-1/2 w-[12px] h-[12px] rounded-[2px] shadow-[0_2px_4px_rgba(0,0,0,0.18)] transform rotate-45 translate-x-[-50%] z-auto"></div>
            <div className="absolute bg-blue-500 text-white flex items-center justify-center w-12 h-12 rounded-full shadow-[0_2px_4px_rgba(0,0,0,0.18)]">
              <PackageIcon className="block w-6 h-6 text-white" />
            </div>
            <div className="absolute bottom-[-1px] left-1/2 w-[12px] h-[12px] bg-gradient-to-br from-transparent to-blue-500 via-transparent rounded-[2px] transform rotate-45 translate-x-[-50%] z-auto"></div>
          </div>
        </Marker>
      ))}
    </MapGL>
  );
}
