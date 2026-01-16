"use client";

import clsx from "clsx";
import { ChevronDownIcon, ChevronUpIcon } from "lucide-react";
import type React from "react";
import { createContext, forwardRef, useContext, useState } from "react";
import { Link } from "./Link";

const TableContext = createContext<{
  bleed: boolean;
  dense: boolean;
  grid: boolean;
  striped: boolean;
}>({
  bleed: false,
  dense: false,
  grid: false,
  striped: false,
});

export function Table({
  bleed = false,
  dense = false,
  grid = false,
  striped = false,
  className,
  children,
  ...props
}: {
  bleed?: boolean;
  dense?: boolean;
  grid?: boolean;
  striped?: boolean;
} & React.ComponentPropsWithoutRef<"div">) {
  return (
    <TableContext.Provider
      value={
        { bleed, dense, grid, striped } as React.ContextType<
          typeof TableContext
        >
      }
    >
      <div className="flow-root">
        <div
          {...props}
          className={clsx(
            className,
            "-mx-(--gutter) overflow-x-auto whitespace-nowrap",
          )}
        >
          <div
            className={clsx(
              "inline-block min-w-full align-middle",
              !bleed && "sm:px-(--gutter)",
            )}
          >
            <table className="min-w-full text-left text-sm/6 text-zinc-950 dark:text-white">
              {children}
            </table>
          </div>
        </div>
      </div>
    </TableContext.Provider>
  );
}

export function TableHead({
  className,
  ...props
}: React.ComponentPropsWithoutRef<"thead">) {
  return (
    <thead
      {...props}
      className={clsx(
        className,
        "text-zinc-500 dark:text-zinc-400",
        "sticky top-0 z-10",
      )}
    />
  );
}

export function TableBody(props: React.ComponentPropsWithoutRef<"tbody">) {
  return <tbody {...props} />;
}

const TableRowContext = createContext<{
  href?: string;
  target?: string;
  title?: string;
}>({
  href: undefined,
  target: undefined,
  title: undefined,
});

export const TableRow = forwardRef<
  HTMLTableRowElement,
  {
    href?: string;
    target?: string;
    title?: string;
  } & React.ComponentPropsWithoutRef<"tr">
>(({ href, target, title, className, ...props }, ref) => {
  const { striped } = useContext(TableContext);

  return (
    <TableRowContext.Provider
      value={
        { href, target, title } as React.ContextType<typeof TableRowContext>
      }
    >
      <tr
        ref={ref}
        {...props}
        className={clsx(
          className,
          href &&
            "has-[[data-row-link][data-focus]]:outline-2 has-[[data-row-link][data-focus]]:-outline-offset-2 has-[[data-row-link][data-focus]]:outline-blue-500 dark:focus-within:bg-white/2.5",
          striped && "even:bg-zinc-950/2.5 dark:even:bg-white/2.5",
          href && striped && "hover:bg-zinc-950/5 dark:hover:bg-white/5",
          href && !striped && "hover:bg-zinc-950/2.5 dark:hover:bg-white/2.5",
        )}
      />
    </TableRowContext.Provider>
  );
});

export function TableHeader({
  className,
  ...props
}: React.ComponentPropsWithoutRef<"th">) {
  const { bleed, grid } = useContext(TableContext);

  return (
    <th
      {...props}
      className={clsx(
        className,
        "border-b border-b-zinc-950/10 px-4 py-2 font-medium first:pl-(--gutter,--spacing(2)) last:pr-(--gutter,--spacing(2)) dark:border-b-white/10",
        grid &&
          "border-l border-l-zinc-950/5 first:border-l-0 dark:border-l-white/5",
        !bleed && "sm:first:pl-1 sm:last:pr-1",
      )}
    />
  );
}

export function TableCell({
  className,
  children,
  ...props
}: React.ComponentPropsWithoutRef<"td">) {
  const { bleed, dense, grid, striped } = useContext(TableContext);
  const { href, target, title } = useContext(TableRowContext);
  const [cellRef, setCellRef] = useState<HTMLElement | null>(null);

  return (
    <td
      ref={href ? setCellRef : undefined}
      {...props}
      className={clsx(
        className,
        "relative px-4 first:pl-(--gutter,--spacing(2)) last:pr-(--gutter,--spacing(2))",
        !striped && "border-b border-zinc-950/5 dark:border-white/5",
        grid &&
          "border-l border-l-zinc-950/5 first:border-l-0 dark:border-l-white/5",
        dense ? "py-2.5" : "py-4",
        !bleed && "sm:first:pl-1 sm:last:pr-1",
      )}
    >
      {href && (
        <Link
          data-row-link
          href={href}
          target={target}
          aria-label={title}
          tabIndex={cellRef?.previousElementSibling === null ? 0 : -1}
          className="absolute inset-0 focus:outline-hidden"
        />
      )}
      {children}
    </td>
  );
}

type TableSortIndicatorProps = {
  sortDirection?: "asc" | "desc";
};

export function TableSortIndicator({ sortDirection }: TableSortIndicatorProps) {
  return (
    <div className="flex flex-col">
      <ChevronUpIcon
        className={clsx(
          "h-3 w-3 -mb-1",
          sortDirection === "asc"
            ? "text-zinc-900 dark:text-white"
            : "text-zinc-300 dark:text-zinc-600",
        )}
      />
      <ChevronDownIcon
        className={clsx(
          "h-3 w-3 -mb-1",
          sortDirection === "desc"
            ? "text-zinc-900 dark:text-white"
            : "text-zinc-300 dark:text-zinc-600",
        )}
      />
    </div>
  );
}

export function TableFoot({
  className,
  ...props
}: React.ComponentPropsWithoutRef<"tfoot">) {
  return (
    <tfoot
      {...props}
      className={clsx(
        className,
        "text-zinc-500 dark:text-zinc-400",
        "sticky top-0 z-10",
      )}
    />
  );
}

export function TableFooter({
  className,
  ...props
}: React.ComponentPropsWithoutRef<"th">) {
  const { bleed, grid } = useContext(TableContext);

  return (
    <th
      {...props}
      className={clsx(
        className,
        "border-t border-t-zinc-950/10 px-4 py-2 font-medium first:pl-(--gutter,--spacing(2)) last:pr-(--gutter,--spacing(2)) dark:border-t-white/10",
        grid &&
          "border-l border-l-zinc-950/5 first:border-l-0 dark:border-l-white/5",
        !bleed && "sm:first:pl-1 sm:last:pr-1",
      )}
    />
  );
}
