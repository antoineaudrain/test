import { Time } from "@/lib/time";

export function isPast(date: Date | string | number): boolean {
  return Time(date).isBefore(Time(), "day");
}

export function isToday(date: Date | string | number): boolean {
  return Time(date).isSame(Time(), "day");
}

export function isFuture(date: Date | string | number): boolean {
  return Time(date).isAfter(Time(), "day");
}

export function isWithinStartWindow(date: Date | string | number): boolean {
  const deliveryDate = Time(date);
  const now = Time();
  const hoursSinceDeliveryDate = now.diff(deliveryDate, "hour");
  const hoursUntilDeliveryDate = deliveryDate.diff(now, "hour");

  return hoursUntilDeliveryDate <= 0 && hoursSinceDeliveryDate <= 24;
}

export function isTodayOrWithinStartWindow(
  date: Date | string | number,
): boolean {
  return isToday(date) || isWithinStartWindow(date);
}
