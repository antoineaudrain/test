"use client";

import * as Headless from "@headlessui/react";
import clsx from "clsx";
import type React from "react";
import { forwardRef, useEffect, useRef } from "react";

type TextareaProps = {
  className?: string;
  resizable?: boolean;
} & Omit<Headless.TextareaProps, "as" | "className">;

export const Textarea = forwardRef<HTMLTextAreaElement, TextareaProps>(
  ({ className, resizable = true, autoFocus, ...props }, ref) => {
    const localRef = useRef<HTMLTextAreaElement | null>(null);

    useEffect(() => {
      if (!autoFocus && document.activeElement === localRef.current) {
        requestAnimationFrame(() => localRef.current?.blur());
      }
    }, [autoFocus]);

    const assignRef = <T,>(r: React.Ref<T> | undefined, value: T) => {
      if (!r) return;
      if (typeof r === "function") r(value);
      else (r as React.RefObject<T>).current = value;
    };

    return (
      <span
        data-slot="control"
        className={clsx([
          className,
          // Basic layout
          "cursor-text relative block w-full",
          // Background color + shadow applied to inset pseudo element, so shadow blends with border in light mode
          "before:pointer-events-none before:absolute before:inset-px before:rounded-[calc(var(--radius-lg)-1px)] before:bg-white before:shadow-sm",
          // Background color is moved to control and shadow is removed in dark mode so hide `before` pseudo
          "dark:before:hidden",
          // Focus ring
          "after:pointer-events-none after:absolute after:inset-0 after:rounded-lg after:ring-transparent after:ring-inset sm:focus-within:after:ring-2 sm:focus-within:after:ring-blue-500",
          // Disabled state
          "cursor-default has-data-disabled:opacity-50 has-data-disabled:before:bg-zinc-950/5 has-data-disabled:before:shadow-none",
        ])}
      >
        <Headless.Textarea
          ref={(el) => {
            localRef.current = el as HTMLTextAreaElement | null;
            assignRef(ref, el);
          }}
          {...props}
          className={clsx([
            // Basic layout
            "relative block h-full w-full appearance-none rounded-lg px-[calc(--spacing(3.5)-1px)] py-[calc(--spacing(2.5)-1px)] sm:px-[calc(--spacing(3)-1px)] sm:py-[calc(--spacing(1.5)-1px)]",
            // Typography
            "text-base/6 text-zinc-950 placeholder:text-zinc-500 sm:text-sm/6 dark:text-white",
            // Border
            "border border-zinc-950/10 data-hover:border-zinc-950/20 dark:border-white/10 dark:data-hover:border-white/20",
            // Background color
            "bg-transparent dark:bg-white/5",
            // Hide default focus styles
            "focus:outline-hidden",
            // Invalid state
            "data-invalid:border-red-500 data-invalid:data-hover:border-red-500 dark:data-invalid:border-red-600 dark:data-invalid:data-hover:border-red-600",
            // Disabled state
            "disabled:border-zinc-950/20 dark:disabled:border-white/15 dark:disabled:bg-white/2.5 dark:data-hover:disabled:border-white/15",
            // Resizable
            resizable ? "resize-y" : "resize-none",
          ])}
        />
      </span>
    );
  },
);
