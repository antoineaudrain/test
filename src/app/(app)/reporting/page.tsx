import { listDeliveriesByDateRange } from "@/features/reporting/actions/queries/listDeliveriesByDateRange";
import {
  ClientDeliverySummaryTable,
  type ClientDeliverySummaryTableRow,
} from "@/features/reporting/components/ClientDeliverySummaryTable";
import { DateRangeFilter } from "@/features/reporting/components/DateRangeFilter";
import { Heading, Subheading, Text } from "@/features/shared/components";
import { requirePermission } from "@/lib/permissions";
import { Time } from "@/lib/time";

type ReportingPageProps = {
  searchParams: Promise<{
    dateFrom?: string;
    dateTo?: string;
  }>;
};

export default async function ReportingPage({
  searchParams,
}: ReportingPageProps) {
  await requirePermission((policies) => policies.canViewReportingPage());

  const params = await searchParams;
  const dateFrom =
    params.dateFrom || Time().startOf("month").format("YYYY-MM-DD");
  const dateTo = params.dateTo || Time().endOf("month").format("YYYY-MM-DD");

  const deliveries = await listDeliveriesByDateRange({
    dateFrom,
    dateTo,
  });

  // Aggregate data by end client
  const endClientStats = new Map<string, ClientDeliverySummaryTableRow>();

  for (const delivery of deliveries) {
    for (const stop of delivery.stops) {
      if (!stop.endClientCompany) continue;

      const endClientId = stop.endClientCompany.id;

      if (!endClientStats.has(endClientId)) {
        endClientStats.set(endClientId, {
          endClientId,
          endClientName: stop.endClientCompany.name,
          endClientAddress: stop.endClientCompany.address.formattedAddress,
          totalPickups: 0,
          totalDropoffs: 0,
          totalStops: 0,
        });
      }

      const stats = endClientStats.get(endClientId)!;
      stats.totalStops += 1;

      if (stop.type === "PICKUP" || stop.type === "BOTH") {
        stats.totalPickups += 1;
      }
      if (stop.type === "DROPOFF" || stop.type === "BOTH") {
        stats.totalDropoffs += 1;
      }
    }
  }

  const data = Array.from(endClientStats.values());

  const totalDeliveries = deliveries.length;
  const totalStops = data.reduce((sum, row) => sum + row.totalStops, 0);
  const totalPickups = data.reduce((sum, row) => sum + row.totalPickups, 0);
  const totalDropoffs = data.reduce((sum, row) => sum + row.totalDropoffs, 0);

  return (
    <div className="space-y-8">
      <div className="flex flex-wrap items-end justify-between gap-4">
        <div className="flex flex-col max-sm:w-full sm:flex-1 gap-y-2">
          <Heading>Rapports de Livraisons</Heading>
          <Text>
            Consultez les statistiques de vos livraisons complétées par client
            final
          </Text>
        </div>
      </div>

      <DateRangeFilter />

      {/* Summary Stats */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        <div className="bg-white dark:bg-zinc-900 rounded-xl border border-zinc-200 dark:border-zinc-800 p-4">
          <Text className="text-sm text-zinc-600 dark:text-zinc-400">
            Total Livraisons
          </Text>
          <div className="text-2xl font-bold text-zinc-900 dark:text-white mt-1">
            {totalDeliveries}
          </div>
        </div>
        <div className="bg-white dark:bg-zinc-900 rounded-xl border border-zinc-200 dark:border-zinc-800 p-4">
          <Text className="text-sm text-zinc-600 dark:text-zinc-400">
            Total Passages
          </Text>
          <div className="text-2xl font-bold text-zinc-900 dark:text-white mt-1">
            {totalStops}
          </div>
        </div>
        <div className="bg-white dark:bg-zinc-900 rounded-xl border border-zinc-200 dark:border-zinc-800 p-4">
          <Text className="text-sm text-zinc-600 dark:text-zinc-400">
            Total Collectes
          </Text>
          <div className="text-2xl font-bold text-zinc-900 dark:text-white mt-1">
            {totalPickups}
          </div>
        </div>
        <div className="bg-white dark:bg-zinc-900 rounded-xl border border-zinc-200 dark:border-zinc-800 p-4">
          <Text className="text-sm text-zinc-600 dark:text-zinc-400">
            Total Livraisons
          </Text>
          <div className="text-2xl font-bold text-zinc-900 dark:text-white mt-1">
            {totalDropoffs}
          </div>
        </div>
      </div>

      <div>
        <Subheading className="mb-4">Détails par Client Final</Subheading>
        <ClientDeliverySummaryTable data={data} />
      </div>
    </div>
  );
}
