import clsx from "clsx";

import type { PropsWithChildren } from "react";
import { Strong, Text } from "@/features/shared/components/index";

type EmptyStateProps = PropsWithChildren<{
  icon: any;
  title: string;
  description: string;
  className?: string;
}>;

export function EmptyState({
  icon: Icon,
  title,
  description,
  className,
  children,
}: EmptyStateProps) {
  return (
    <div
      className={clsx(
        className,
        "flex flex-col items-center justify-center py-12 px-4 text-center sm:py-16 sm:px-6",
      )}
    >
      <Icon
        className="h-36 w-36 text-zinc-400 dark:text-zinc-500 sm:h-48 sm:w-48"
        aria-hidden="true"
      />

      <div className="mx-auto mt-4 sm:mt-6">
        <Strong className="text-lg sm:text-xl">{title}</Strong>
        <Text className="mt-2">{description}</Text>
      </div>

      {children && <div className="mt-6 sm:mt-8">{children}</div>}
    </div>
  );
}
