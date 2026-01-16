import dayjs from "dayjs";
import "dayjs/locale/fr";
import isSameOrBefore from "dayjs/plugin/isSameOrBefore";
import localizedFormat from "dayjs/plugin/localizedFormat";
import relativeTime from "dayjs/plugin/relativeTime";
import timezone from "dayjs/plugin/timezone";
import utc from "dayjs/plugin/utc";

dayjs.extend(localizedFormat);
dayjs.extend(isSameOrBefore);
dayjs.extend(relativeTime);
dayjs.extend(utc);
dayjs.extend(timezone);

dayjs.locale("fr");
dayjs.tz.setDefault("Europe/Paris");

const APP_TIMEZONE = "Europe/Paris";

export const Time = dayjs;

export function dateStringToDate(dateString: string): Date {
  return dayjs.tz(dateString, APP_TIMEZONE).toDate();
}

export function now(): Date {
  return dayjs.tz(undefined, APP_TIMEZONE).toDate();
}

export function formatDateString(date: Date): string {
  return dayjs.tz(date, APP_TIMEZONE).format("YYYY-MM-DD");
}

export function startOfToday(): Date {
  return dayjs.tz(undefined, APP_TIMEZONE).startOf("day").toDate();
}

export function monthRange(monthString: string): { start: Date; end: Date } {
  const start = dayjs.tz(`${monthString}-01`, APP_TIMEZONE).startOf("month");
  const end = start.add(1, "month");
  return {
    start: start.toDate(),
    end: end.toDate(),
  };
}
