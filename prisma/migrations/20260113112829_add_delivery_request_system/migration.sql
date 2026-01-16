-- CreateTable
CREATE TABLE "delivery_requests" (
    "id" TEXT NOT NULL,
    "date" TIMESTAMPTZ(6) NOT NULL,
    "notes" TEXT,
    "client_company_id" TEXT NOT NULL,
    "delivery_company_id" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "delivery_requests_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "delivery_request_stops" (
    "id" TEXT NOT NULL,
    "sequence" INTEGER NOT NULL,
    "type" "step_type" NOT NULL,
    "notes" TEXT,
    "request_id" TEXT NOT NULL,
    "address_id" TEXT NOT NULL,
    "end_client_id" TEXT NOT NULL,
    "delivery_stop_id" TEXT,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "delivery_request_stops_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "client_settings" (
    "id" TEXT NOT NULL,
    "client_company_id" TEXT NOT NULL,
    "cutoff_time" TEXT,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "client_settings_pkey" PRIMARY KEY ("id")
);

-- AlterTable deliveries
-- First, ensure all deliveries have a number (generate for those that don't)
WITH numbered_deliveries AS (
  SELECT id, ROW_NUMBER() OVER (ORDER BY created_at) as rn
  FROM "deliveries"
  WHERE "number" IS NULL
)
UPDATE "deliveries" d
SET "number" = 'TDS' || TO_CHAR(CURRENT_DATE, 'YY') || '-' || LPAD(nd.rn::TEXT, 4, '0')
FROM numbered_deliveries nd
WHERE d.id = nd.id;

-- Now alter the table
ALTER TABLE "deliveries" DROP COLUMN "request_status";
ALTER TABLE "deliveries" ALTER COLUMN "number" SET NOT NULL;

-- DropEnum (after dropping the column that uses it)
DROP TYPE "request_statuses";
ALTER TABLE "deliveries" ALTER COLUMN "notes" SET DATA TYPE TEXT;
ALTER TABLE "deliveries" ALTER COLUMN "driver_notes" SET DATA TYPE TEXT;
ALTER TABLE "deliveries" ALTER COLUMN "delivery_status" SET NOT NULL;
ALTER TABLE "deliveries" ALTER COLUMN "delivery_status" SET DEFAULT 'scheduled';

-- Update any NULL delivery_status to SCHEDULED
UPDATE "deliveries" SET "delivery_status" = 'scheduled' WHERE "delivery_status" IS NULL;

-- AlterTable stops
ALTER TABLE "stops" ALTER COLUMN "notes" SET DATA TYPE TEXT;
ALTER TABLE "stops" ALTER COLUMN "driver_notes" SET DATA TYPE TEXT;

-- CreateIndex
CREATE UNIQUE INDEX "delivery_requests_client_company_id_date_key" ON "delivery_requests"("client_company_id", "date");

-- CreateIndex
CREATE INDEX "delivery_requests_delivery_company_id_date_idx" ON "delivery_requests"("delivery_company_id", "date");

-- CreateIndex
CREATE INDEX "delivery_request_stops_request_id_sequence_idx" ON "delivery_request_stops"("request_id", "sequence");

-- CreateIndex
CREATE INDEX "delivery_request_stops_delivery_stop_id_idx" ON "delivery_request_stops"("delivery_stop_id");

-- CreateIndex
CREATE INDEX "delivery_request_stops_end_client_id_idx" ON "delivery_request_stops"("end_client_id");

-- CreateIndex
CREATE UNIQUE INDEX "delivery_request_stops_delivery_stop_id_key" ON "delivery_request_stops"("delivery_stop_id");

-- CreateIndex
CREATE UNIQUE INDEX "client_settings_client_company_id_key" ON "client_settings"("client_company_id");

-- CreateIndex
CREATE UNIQUE INDEX "deliveries_number_key" ON "deliveries"("number");

-- CreateIndex
CREATE INDEX "deliveries_delivery_company_id_date_idx" ON "deliveries"("delivery_company_id", "date");

-- AddForeignKey
ALTER TABLE "delivery_requests" ADD CONSTRAINT "delivery_requests_client_company_id_fkey" FOREIGN KEY ("client_company_id") REFERENCES "companies"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "delivery_requests" ADD CONSTRAINT "delivery_requests_delivery_company_id_fkey" FOREIGN KEY ("delivery_company_id") REFERENCES "companies"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "delivery_request_stops" ADD CONSTRAINT "delivery_request_stops_request_id_fkey" FOREIGN KEY ("request_id") REFERENCES "delivery_requests"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "delivery_request_stops" ADD CONSTRAINT "delivery_request_stops_address_id_fkey" FOREIGN KEY ("address_id") REFERENCES "addresses"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "delivery_request_stops" ADD CONSTRAINT "delivery_request_stops_end_client_id_fkey" FOREIGN KEY ("end_client_id") REFERENCES "companies"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "delivery_request_stops" ADD CONSTRAINT "delivery_request_stops_delivery_stop_id_fkey" FOREIGN KEY ("delivery_stop_id") REFERENCES "stops"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "client_settings" ADD CONSTRAINT "client_settings_client_company_id_fkey" FOREIGN KEY ("client_company_id") REFERENCES "companies"("id") ON DELETE CASCADE ON UPDATE CASCADE;
