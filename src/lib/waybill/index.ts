import { PDFDocument } from "pdf-lib";
import { Time } from "@/lib/time";

interface Client {
  name: string;
  address: string;
}

interface SignatureInfo {
  signedAtClient: Date;
  signedAtDriver: Date;
}

interface TransportInfo extends SignatureInfo {
  client: Client;
  onsiteArrival: Date;
  onsiteDeparture: Date;
  services: string;
}

interface PickupInfo extends TransportInfo {
  requestedDeliveryDate: Date;
}

interface DeliveryInfo extends TransportInfo {
  deliveredAt?: Date;
}

interface TransportDetails {
  driverName: string;
  vehicleLicensePlate: string;
  services: string;
}

export interface WaybillData extends TransportDetails {
  waybillNumber: string;
  pickup: PickupInfo;
  delivery: DeliveryInfo;
}

export class WaybillGenerator {
  private templateBytes: Uint8Array | null = null;

  async loadTemplate(): Promise<void> {
    const response = await fetch("/templates/waybill.pdf");
    this.templateBytes = new Uint8Array(await response.arrayBuffer());
  }

  async getFilledPDFAsBase64(data: WaybillData): Promise<string> {
    if (!this.templateBytes) await this.loadTemplate();
    if (!this.templateBytes) {
      throw new Error("Failed to load PDF template");
    }

    const pdfDoc = await PDFDocument.load(this.templateBytes);
    const form = pdfDoc.getForm();

    const setText = (name: string, value: string) => {
      try {
        const field = form.getTextField(name);
        field.setText(value || "");
      } catch {
        console.warn(`Field "${name}" not found`);
      }
    };

    setText("waybill_id", data.waybillNumber);
    setText("delivered_at", this.#formatDate(data.delivery.deliveredAt));
    setText("tractor_license_plate", data.vehicleLicensePlate);
    setText("driver_name", data.driverName || "");

    setText("services", data.services || "");

    setText("sender_name", data.pickup.client.name);
    setText("sender_address", data.pickup.client.address);
    setText("sender_arrival_date", this.#formatDate(data.pickup.onsiteArrival));
    setText("sender_arrival_hour", this.#formatHour(data.pickup.onsiteArrival));
    setText(
      "sender_arrival_minute",
      this.#formatMinute(data.pickup.onsiteArrival),
    );
    setText(
      "sender_departure_date",
      this.#formatDate(data.pickup.onsiteDeparture),
    );
    setText(
      "sender_departure_hour",
      this.#formatHour(data.pickup.onsiteDeparture),
    );
    setText(
      "sender_departure_minute",
      this.#formatMinute(data.pickup.onsiteDeparture),
    );
    setText(
      "sender_requested_delivery_date",
      this.#formatDate(data.pickup.requestedDeliveryDate),
    );
    setText(
      "sender_requested_delivery_hour",
      this.#formatHour(data.pickup.requestedDeliveryDate),
    );
    setText(
      "sender_requested_delivery_minute",
      this.#formatMinute(data.pickup.requestedDeliveryDate),
    );
    setText(
      "pickup_driver_signed_at",
      this.#formatDate(data.pickup.signedAtDriver),
    );
    setText(
      "pickup_sender_signed_at",
      this.#formatDate(data.pickup.signedAtClient),
    );
    setText("pickup_services", data.pickup.services);

    setText("recipient_name", data.delivery.client.name);
    setText("recipient_address", data.delivery.client.address);
    setText(
      "recipient_arrival_date",
      this.#formatDate(data.delivery.onsiteArrival),
    );
    setText(
      "recipient_arrival_hour",
      this.#formatHour(data.delivery.onsiteArrival),
    );
    setText(
      "recipient_arrival_minute",
      this.#formatMinute(data.delivery.onsiteArrival),
    );
    setText(
      "recipient_departure_date",
      this.#formatDate(data.delivery.onsiteDeparture),
    );
    setText(
      "recipient_departure_hour",
      this.#formatHour(data.delivery.onsiteDeparture),
    );
    setText(
      "recipient_departure_minute",
      this.#formatMinute(data.delivery.onsiteDeparture),
    );
    setText(
      "delivery_driver_signed_at",
      this.#formatDate(data.delivery.signedAtDriver),
    );
    setText(
      "delivery_recipient_signed_at",
      this.#formatDate(data.delivery.signedAtClient),
    );
    setText("delivery_services", data.delivery.services);

    form.flatten();

    const pdfBytes = await pdfDoc.save();

    let binary = "";
    for (let i = 0; i < pdfBytes.length; i++) {
      binary += String.fromCharCode(pdfBytes[i]);
    }
    const base64 = btoa(binary);

    return `data:application/pdf;base64,${base64}`;
  }

  #formatDate(date?: Date) {
    return date ? Time(date).format("DD/MM/YYYY") : "";
  }

  #formatHour(date?: Date) {
    return date ? Time(date).format("HH") : "";
  }

  #formatMinute(date?: Date) {
    return date ? Time(date).format("mm") : "";
  }
}
