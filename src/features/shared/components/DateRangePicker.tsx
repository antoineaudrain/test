"use client";

import * as Headless from "@headlessui/react";
import clsx from "clsx";
import { format } from "date-fns";
import { fr } from "date-fns/locale";
import { CalendarIcon, XIcon } from "lucide-react";
import { type DateRange, DayPicker } from "react-day-picker";
import { Button } from "@/features/shared/components";

type DateRangePickerProps = {
  value: DateRange | undefined;
  onChange: (range: DateRange | undefined) => void;
  disabled?: boolean;
  placeholder?: string;
};

export function DateRangePicker({
  value,
  onChange,
  disabled = false,
  placeholder = "Sélectionner une période",
}: DateRangePickerProps) {
  const formatDateRange = (range: DateRange | undefined) => {
    if (!range) return placeholder;
    if (!range.from) return placeholder;
    if (!range.to) return format(range.from, "d MMM yyyy", { locale: fr });
    return `${format(range.from, "d MMM", { locale: fr })} - ${format(range.to, "d MMM yyyy", { locale: fr })}`;
  };

  const handleReset = (e: React.MouseEvent) => {
    e.stopPropagation();
    onChange(undefined);
  };

  return (
    <Headless.Popover className="relative">
      <Headless.PopoverButton
        as={Button}
        outline
        disabled={disabled}
        className={clsx(
          "min-w-[260px] justify-between gap-2",
          !value && "text-zinc-500 dark:text-zinc-400",
        )}
      >
        <span className="flex items-center gap-2 truncate">
          <CalendarIcon className="size-4 shrink-0" />
          <span className="truncate font-medium">{formatDateRange(value)}</span>
        </span>
        {value && (
          <button
            type="button"
            onClick={handleReset}
            className="ml-1 shrink-0 rounded p-1 transition-colors hover:bg-zinc-200 dark:hover:bg-zinc-700"
          >
            <XIcon className="size-3.5" />
          </button>
        )}
      </Headless.PopoverButton>

      <Headless.PopoverPanel
        transition
        anchor="bottom start"
        className={clsx(
          "[--anchor-gap:8px] [--anchor-padding:8px]",
          "isolate rounded-xl p-4",
          "bg-white/95 backdrop-blur-xl dark:bg-zinc-800/95",
          "shadow-xl ring-1 ring-zinc-950/10 dark:ring-white/10",
          "transition duration-200 ease-out data-closed:scale-95 data-closed:opacity-0",
        )}
      >
        <style>{`
          .rdp-root {
            --rdp-accent-color: rgb(59 130 246);
            --rdp-accent-background-color: rgb(59 130 246);
            --rdp-day_button-border-radius: 0.5rem;
            --rdp-day_button-height: 2.25rem;
            --rdp-day_button-width: 2.25rem;
            --rdp-range_start-date-background-color: rgb(59 130 246);
            --rdp-range_end-date-background-color: rgb(59 130 246);
            --rdp-range_middle-background-color: rgb(219 234 254);
            --rdp-range_middle-color: rgb(30 58 138);
            font-family: inherit;
          }

          .dark .rdp-root {
            --rdp-accent-color: rgb(59 130 246);
            --rdp-accent-background-color: rgb(59 130 246);
            --rdp-range_middle-background-color: rgb(30 58 138);
            --rdp-range_middle-color: rgb(219 234 254);
          }

          .rdp-root {
            color: rgb(24 24 27);
          }

          .dark .rdp-root {
            color: rgb(250 250 250);
          }

          .rdp-months {
            display: flex;
            gap: 1rem;
          }

          .rdp-month {
            width: 280px;
          }

          .rdp-month_caption {
            display: flex;
            align-items: center;
            justify-content: center;
            height: 2.5rem;
            margin-bottom: 0.5rem;
            font-weight: 600;
            font-size: 0.9375rem;
            color: rgb(24 24 27);
            text-transform: capitalize;
          }

          .dark .rdp-month_caption {
            color: rgb(250 250 250);
          }

          .rdp-nav {
            position: absolute;
            top: 0;
            right: 0;
            display: flex;
            gap: 0.25rem;
          }

          .rdp-nav_button {
            width: 2rem;
            height: 2rem;
            border-radius: 0.5rem;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: background-color 150ms;
            color: rgb(113 113 122);
          }

          .dark .rdp-nav_button {
            color: rgb(161 161 170);
          }

          .rdp-nav_button:hover:not([disabled]) {
            background-color: rgb(244 244 245);
            color: rgb(24 24 27);
          }

          .dark .rdp-nav_button:hover:not([disabled]) {
            background-color: rgb(39 39 42);
            color: rgb(250 250 250);
          }

          .rdp-nav_button[disabled] {
            opacity: 0.3;
            cursor: not-allowed;
          }

          .rdp-chevron {
            fill: currentColor;
            width: 1rem;
            height: 1rem;
          }

          .rdp-weekdays {
            display: flex;
            margin-bottom: 0.25rem;
          }

          .rdp-weekday {
            width: 2.25rem;
            height: 2rem;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.6875rem;
            font-weight: 600;
            color: rgb(113 113 122);
            text-transform: uppercase;
            letter-spacing: 0.025em;
          }

          .dark .rdp-weekday {
            color: rgb(161 161 170);
          }

          .rdp-week {
            display: flex;
            gap: 2px;
            margin-bottom: 2px;
          }

          .rdp-day {
            width: 2.25rem;
            height: 2.25rem;
          }

          .rdp-day_button {
            width: 100%;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.875rem;
            font-weight: 500;
            border-radius: 0.5rem;
            transition: all 150ms;
            position: relative;
            color: rgb(24 24 27);
          }

          .dark .rdp-day_button {
            color: rgb(250 250 250);
          }

          .rdp-day_button:hover:not([disabled]):not(.rdp-day_selected) {
            background-color: rgb(244 244 245);
          }

          .dark .rdp-day_button:hover:not([disabled]):not(.rdp-day_selected) {
            background-color: rgb(39 39 42);
          }

          .rdp-day_button[disabled] {
            opacity: 0.25;
            cursor: not-allowed;
          }

          .rdp-day_button.rdp-day_selected {
            background-color: rgb(59 130 246);
            color: white;
            font-weight: 600;
          }

          .rdp-day_button.rdp-day_selected:hover {
            background-color: rgb(37 99 235);
          }

          .rdp-day_button.rdp-day_today:not(.rdp-day_selected) {
            font-weight: 600;
            color: rgb(59 130 246);
            position: relative;
          }

          .rdp-day_button.rdp-day_today:not(.rdp-day_selected)::after {
            content: '';
            position: absolute;
            bottom: 3px;
            left: 50%;
            transform: translateX(-50%);
            width: 4px;
            height: 4px;
            border-radius: 50%;
            background-color: rgb(59 130 246);
          }

          .dark .rdp-day_button.rdp-day_today:not(.rdp-day_selected) {
            color: rgb(96 165 250);
          }

          .dark .rdp-day_button.rdp-day_today:not(.rdp-day_selected)::after {
            background-color: rgb(96 165 250);
          }

          .rdp-day_button.rdp-range_start,
          .rdp-day_button.rdp-range_end {
            background-color: rgb(59 130 246);
            color: white;
          }

          .rdp-day_button.rdp-range_middle {
            background-color: rgb(219 234 254);
            color: rgb(30 58 138);
            border-radius: 0;
          }

          .dark .rdp-day_button.rdp-range_middle {
            background-color: rgb(30 58 138);
            color: rgb(219 234 254);
          }

          .rdp-day_button.rdp-range_start {
            border-top-right-radius: 0;
            border-bottom-right-radius: 0;
          }

          .rdp-day_button.rdp-range_end {
            border-top-left-radius: 0;
            border-bottom-left-radius: 0;
          }

          .rdp-day_button.rdp-range_start.rdp-range_end {
            border-radius: 0.5rem;
          }

          .rdp-outside {
            opacity: 0;
            pointer-events: none;
          }
        `}</style>
        <DayPicker
          mode="range"
          selected={value}
          onSelect={onChange}
          locale={fr}
          numberOfMonths={1}
          showOutsideDays={false}
        />
      </Headless.PopoverPanel>
    </Headless.Popover>
  );
}
