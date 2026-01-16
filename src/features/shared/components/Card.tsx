import clsx from "clsx";
import type React from "react";

export function Card({
  className,
  ...props
}: React.ComponentPropsWithoutRef<"div">) {
  return (
    <div
      {...props}
      className={clsx(
        className,
        "rounded-lg border border-zinc-950/10 bg-white dark:border-white/10 dark:bg-zinc-900",
      )}
    />
  );
}

export function CardHeader({
  className,
  ...props
}: React.ComponentPropsWithoutRef<"div">) {
  return (
    <div
      {...props}
      className={clsx(
        className,
        "border-b border-zinc-950/10 px-6 py-4 dark:border-white/10",
      )}
    />
  );
}

export function CardTitle({
  className,
  ...props
}: React.ComponentPropsWithoutRef<"h3">) {
  return (
    <h3
      {...props}
      className={clsx(
        className,
        "text-lg font-semibold text-zinc-950 dark:text-white",
      )}
    />
  );
}

export function CardContent({
  className,
  ...props
}: React.ComponentPropsWithoutRef<"div">) {
  return <div {...props} className={clsx(className, "px-6 py-4")} />;
}
