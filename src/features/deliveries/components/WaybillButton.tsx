"use client";

import { FileTextIcon } from "lucide-react";
import { useRef, useState } from "react";
import type { DeliveryWithRelations } from "@/features/deliveries/types";
import { Button } from "@/features/shared/components";
import { type WaybillData, WaybillGenerator } from "@/lib/waybill";

type WaybillButtonProps = {
  delivery: DeliveryWithRelations<{
    deliveryCompany: true;
    clientCompany: {
      include: {
        address: true;
      };
    };
    driver: true;
    vehicle: true;
    stops: {
      include: {
        endClientCompany: {
          include: {
            address: true;
          };
        };
      };
    };
  }>;
};

export function WaybillButton({ delivery }: WaybillButtonProps) {
  const [loading, setLoading] = useState(false);
  const generator = useRef(new WaybillGenerator()).current;

  const formatAddress = (addr?: string) => addr?.replace(/,\s*/, "\n") ?? "";

  const generateAndOpenWaybill = async () => {
    const { startedAt, finishedAt } = delivery;
    if (!delivery.driverName || !delivery.vehicleLicensePlate)
      return alert("Driver or vehicle missing");
    if (!startedAt || !finishedAt)
      return alert("Missing required delivery dates");

    setLoading(true);

    try {
      const waybillData: WaybillData = {
        waybillNumber: delivery.number ?? "",
        driverName: delivery.driverName ?? "",
        vehicleLicensePlate: delivery.vehicleLicensePlate ?? "",
        services: "Prothèses dentaires",
        pickup: {
          client: {
            name: delivery.clientCompany?.name ?? "",
            address: formatAddress(
              delivery.clientCompany?.address?.formattedAddress,
            ),
          },
          onsiteArrival: startedAt,
          onsiteDeparture: startedAt,
          requestedDeliveryDate: startedAt,
          services: "",
          signedAtClient: startedAt,
          signedAtDriver: startedAt,
        },
        delivery: {
          client: {
            name: delivery.clientCompany?.name ?? "",
            address: formatAddress(
              delivery.clientCompany?.address?.formattedAddress,
            ),
          },
          onsiteArrival: finishedAt,
          onsiteDeparture: finishedAt,
          services: "",
          signedAtClient: finishedAt,
          signedAtDriver: finishedAt,
          deliveredAt: finishedAt,
        },
      };

      const base64PDF = await generator.getFilledPDFAsBase64(waybillData);
      const blob = await (await fetch(base64PDF)).blob();
      window.open(URL.createObjectURL(blob), "_blank");
    } catch (e: any) {
      console.error(e);
      alert(e.message || "Erreur lors de la génération du PDF.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <Button
      onClick={generateAndOpenWaybill}
      loading={loading}
      className="flex items-center gap-2"
    >
      <FileTextIcon className="size-4" />
      {loading ? "Génération..." : "Lettre de voiture"}
    </Button>
  );
}
