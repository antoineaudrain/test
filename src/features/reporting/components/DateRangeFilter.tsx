"use client";

import { useRouter, useSearchParams } from "next/navigation";
import { useTransition } from "react";
import { Button, Input } from "@/features/shared/components";
import { Time } from "@/lib/time";

export function DateRangeFilter() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const [isPending, startTransition] = useTransition();

  const dateFrom =
    searchParams.get("dateFrom") || Time().startOf("month").format("YYYY-MM-DD");
  const dateTo =
    searchParams.get("dateTo") || Time().endOf("month").format("YYYY-MM-DD");

  const handleApplyFilter = () => {
    const dateFromInput = document.getElementById("dateFrom") as HTMLInputElement;
    const dateToInput = document.getElementById("dateTo") as HTMLInputElement;

    const params = new URLSearchParams();
    if (dateFromInput.value) params.set("dateFrom", dateFromInput.value);
    if (dateToInput.value) params.set("dateTo", dateToInput.value);

    startTransition(() => {
      router.push(`/reporting?${params.toString()}`);
    });
  };

  const handleReset = () => {
    startTransition(() => {
      router.push("/reporting");
    });
  };

  return (
    <div className="flex flex-col sm:flex-row gap-4 items-start sm:items-end">
      <div className="flex-1 w-full sm:w-auto">
        <label
          htmlFor="dateFrom"
          className="block text-sm font-medium text-zinc-700 dark:text-zinc-300 mb-2"
        >
          Date de début
        </label>
        <Input
          type="date"
          id="dateFrom"
          name="dateFrom"
          defaultValue={dateFrom}
          disabled={isPending}
        />
      </div>

      <div className="flex-1 w-full sm:w-auto">
        <label
          htmlFor="dateTo"
          className="block text-sm font-medium text-zinc-700 dark:text-zinc-300 mb-2"
        >
          Date de fin
        </label>
        <Input
          type="date"
          id="dateTo"
          name="dateTo"
          defaultValue={dateTo}
          disabled={isPending}
        />
      </div>

      <div className="flex gap-2">
        <Button onClick={handleApplyFilter} disabled={isPending}>
          Appliquer
        </Button>
        <Button onClick={handleReset} outline disabled={isPending}>
          Réinitialiser
        </Button>
      </div>
    </div>
  );
}
