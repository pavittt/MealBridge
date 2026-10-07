"use client";
/* Leaflet map for the volunteer page. Loaded only in the browser
   (Leaflet needs `window`), via next/dynamic in the page.
   Coordinates come from MySQL: ST_Latitude / ST_Longitude of site.location. */
import { CircleMarker, MapContainer, Polyline, TileLayer, Tooltip, useMap } from "react-leaflet";
import { useEffect } from "react";

function Fit({ points }) {
  const map = useMap();
  useEffect(() => {
    if (points.length > 1) map.fitBounds(points, { padding: [40, 40] });
    else if (points.length === 1) map.setView(points[0], 14);
  }, [map, JSON.stringify(points)]);    // eslint-disable-line react-hooks/exhaustive-deps
  return null;
}

export default function TripMap({ home, queue, trip }) {
  const pts = [];
  if (home) pts.push([home.lat, home.lon]);
  const route = trip ? [[home.lat, home.lon], ...trip.stops.map((s) => [s.lat, s.lon])] : [];
  (trip ? trip.stops : []).forEach((s) => pts.push([s.lat, s.lon]));
  if (!trip) queue.forEach((q) => { pts.push([q.mess_lat, q.mess_lon]); pts.push([q.shelter_lat, q.shelter_lon]); });

  return (
    <MapContainer center={home ? [home.lat, home.lon] : [12.97, 79.15]} zoom={13} style={{ height: "100%", width: "100%" }} scrollWheelZoom={false}>
      <TileLayer attribution="&copy; OpenStreetMap contributors" url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png" />
      {home && (
        <CircleMarker center={[home.lat, home.lon]} radius={7} pathOptions={{ color: "#4d6a86", fillOpacity: 1 }}>
          <Tooltip>Your start point</Tooltip>
        </CircleMarker>
      )}
      {!trip && queue.map((q) => (
        <Polyline key={q.claim_id} positions={[[q.mess_lat, q.mess_lon], [q.shelter_lat, q.shelter_lon]]}
                  pathOptions={{ color: "#a7a092", weight: 2, dashArray: "4 6" }} />
      ))}
      {!trip && queue.map((q) => (
        <CircleMarker key={"m" + q.claim_id} center={[q.mess_lat, q.mess_lon]} radius={8} pathOptions={{ color: "#5f7f52", fillOpacity: 0.9 }}>
          <Tooltip>{q.mess}: {q.quantity_kg} kg</Tooltip>
        </CircleMarker>
      ))}
      {!trip && queue.map((q) => (
        <CircleMarker key={"s" + q.claim_id} center={[q.shelter_lat, q.shelter_lon]} radius={8} pathOptions={{ color: "#b3261e", fillOpacity: 0.9 }}>
          <Tooltip>{q.shelter}</Tooltip>
        </CircleMarker>
      ))}
      {trip && <Polyline positions={route} pathOptions={{ color: "#b3261e", weight: 4 }} />}
      {trip && trip.stops.map((s) => (
        <CircleMarker key={s.stop_seq} center={[s.lat, s.lon]} radius={11}
                      pathOptions={{ color: s.stop_type === "PICKUP" ? "#5f7f52" : "#b3261e", fillOpacity: s.departed_at ? 0.35 : 0.95 }}>
          <Tooltip permanent direction="top" offset={[0, -8]}>{s.stop_seq}. {s.name}</Tooltip>
        </CircleMarker>
      ))}
      <Fit points={pts} />
    </MapContainer>
  );
}
