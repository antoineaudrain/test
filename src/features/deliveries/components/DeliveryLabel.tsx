import { isFuture, isToday } from "@/features/shared/helper/time";

type DeliveryLabelProps = {
  number?: string | null;
  date: Date;
};

export function DeliveryLabel({ number, date }: DeliveryLabelProps) {
  let deliveryLabel = "";

  if (isFuture(date)) {
    deliveryLabel = "À venir";
  } else if (isToday(date)) {
    deliveryLabel = number ?? "À traiter...";
  } else {
    deliveryLabel = number ?? "-";
  }

  return deliveryLabel;
}
