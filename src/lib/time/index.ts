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

/**
 * Converts a date-only string (YYYY-MM-DD) to a Date object at noon UTC.
 * This avoids timezone boundary issues - the date will be correct in all timezones.
 *
 * Example:
 *   dateStringToDate("2024-01-15") → Date(2024-01-15T12:00:00.000Z)
 *
 * @param dateString - Date string in YYYY-MM-DD format
 * @returns Date object representing the date at noon UTC
 */
export function dateStringToDate(dateString: string): Date {
  // Parse as UTC at noon to avoid timezone boundary issues
  return dayjs.utc(`${dateString}T12:00:00Z`).toDate();
}

/**
 * Converts a Date object to a date-only string (YYYY-MM-DD) in the app timezone.
 *
 * @param date - Date object to format
 * @returns Date string in YYYY-MM-DD format
 */
export function formatDateString(date: Date): string {
  return dayjs.tz(date, APP_TIMEZONE).format("YYYY-MM-DD");
}

/**
 * Returns the current Date object in the app timezone.
 * For date-only operations, prefer using todayDateString() or startOfToday().
 *
 * @returns Current Date object
 */
export function now(): Date {
  return dayjs.tz(undefined, APP_TIMEZONE).toDate();
}

/**
 * Returns today's date as a string (YYYY-MM-DD) in the app timezone.
 * Use this for date-only operations like default values in forms.
 *
 * @returns Today's date in YYYY-MM-DD format
 */
export function todayDateString(): string {
  return dayjs.tz(undefined, APP_TIMEZONE).format("YYYY-MM-DD");
}

/**
 * Returns a Date object representing the start of today in the app timezone.
 * Note: The returned Date is still stored as noon UTC for the date.
 *
 * @returns Date object for start of today
 */
export function startOfToday(): Date {
  const todayString = todayDateString();
  return dateStringToDate(todayString);
}

/**
 * Returns start and end Date objects for a given month (YYYY-MM format).
 *
 * @param monthString - Month string in YYYY-MM format
 * @returns Object with start and end Date objects
 */
export function monthRange(monthString: string): { start: Date; end: Date } {
  const start = dayjs.utc(`${monthString}-01T12:00:00Z`);
  const end = start.add(1, "month");
  return {
    start: start.toDate(),
    end: end.toDate(),
  };
}

/**
 * Checks if a date string represents a past date in the app timezone.
 *
 * @param dateString - Date string in YYYY-MM-DD format
 * @returns true if the date is in the past
 */
export function isPastDate(dateString: string): boolean {
  const today = todayDateString();
  return dateString < today;
}

/**
 * Checks if a date string represents today in the app timezone.
 *
 * @param dateString - Date string in YYYY-MM-DD format
 * @returns true if the date is today
 */
export function isToday(dateString: string): boolean {
  return dateString === todayDateString();
}

/**
 * Checks if a date string represents a future date in the app timezone.
 *
 * @param dateString - Date string in YYYY-MM-DD format
 * @returns true if the date is in the future
 */
export function isFutureDate(dateString: string): boolean {
  const today = todayDateString();
  return dateString > today;
}
