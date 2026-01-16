-- CreateEnum
CREATE TYPE "public"."user_roles" AS ENUM ('admin', 'manager', 'member');

-- CreateEnum
CREATE TYPE "public"."company_types" AS ENUM ('delivery', 'client', 'end_client');

-- CreateEnum
CREATE TYPE "public"."request_statuses" AS ENUM ('pending', 'accepted', 'declined', 'expired');

-- CreateEnum
CREATE TYPE "public"."delivery_statuses" AS ENUM ('scheduled', 'in_progress', 'completed', 'cancelled');

-- CreateEnum
CREATE TYPE "public"."step_type" AS ENUM ('pickup', 'dropoff', 'both');

-- CreateEnum
CREATE TYPE "public"."stop_statuses" AS ENUM ('planned', 'en_route', 'delivered', 'failed');

-- CreateTable
CREATE TABLE "public"."users" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "external_id" TEXT NOT NULL,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "role" "public"."user_roles" NOT NULL,
    "companyId" TEXT NOT NULL,
    "vehicleId" TEXT,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."addresses" (
    "id" TEXT NOT NULL,
    "externalId" TEXT NOT NULL,
    "address" TEXT NOT NULL,
    "city" TEXT NOT NULL,
    "state" TEXT NOT NULL,
    "postalCode" TEXT NOT NULL,
    "country" TEXT NOT NULL,
    "formattedAddress" TEXT NOT NULL,
    "latitude" DOUBLE PRECISION NOT NULL,
    "longitude" DOUBLE PRECISION NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "addresses_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."companies" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "type" "public"."company_types" NOT NULL,
    "address_id" TEXT NOT NULL,
    "parent_id" TEXT,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "companies_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."batches" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "delivery_company_id" TEXT NOT NULL,
    "client_company_id" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL,
    "companyId" TEXT,

    CONSTRAINT "batches_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."batch_items" (
    "id" TEXT NOT NULL,
    "batch_id" TEXT NOT NULL,
    "company_id" TEXT NOT NULL,
    "default_sequence" INTEGER,
    "default_notes" TEXT,
    "default_type" "public"."step_type",
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "batch_items_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."vehicles" (
    "id" TEXT NOT NULL,
    "plate" TEXT NOT NULL,
    "model" TEXT,
    "company_id" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "vehicles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."deliveries" (
    "id" TEXT NOT NULL,
    "number" TEXT,
    "date" TIMESTAMPTZ(6) NOT NULL,
    "notes" TEXT,
    "batch_name" TEXT NOT NULL,
    "driver_name" TEXT,
    "vehicle_license_plate" TEXT,
    "driver_notes" TEXT,
    "request_status" "public"."request_statuses" NOT NULL DEFAULT 'pending',
    "delivery_status" "public"."delivery_statuses",
    "scheduled_at" TIMESTAMPTZ(6),
    "started_at" TIMESTAMPTZ(6),
    "finished_at" TIMESTAMPTZ(6),
    "delivery_batch_id" TEXT NOT NULL,
    "delivery_company_id" TEXT NOT NULL,
    "client_company_id" TEXT NOT NULL,
    "driver_id" TEXT,
    "vehicle_id" TEXT,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "deliveries_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."stops" (
    "id" TEXT NOT NULL,
    "sequence" INTEGER NOT NULL,
    "type" "public"."step_type" NOT NULL DEFAULT 'dropoff',
    "status" "public"."stop_statuses" NOT NULL DEFAULT 'planned',
    "notes" TEXT,
    "driver_notes" TEXT,
    "completed_at" TIMESTAMPTZ(6),
    "image_url" TEXT,
    "delivery_id" TEXT NOT NULL,
    "address_id" TEXT NOT NULL,
    "end_client_id" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL,

    CONSTRAINT "stops_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "public"."users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "users_external_id_key" ON "public"."users"("external_id");

-- CreateIndex
CREATE INDEX "users_companyId_vehicleId_idx" ON "public"."users"("companyId", "vehicleId");

-- CreateIndex
CREATE INDEX "addresses_city_state_postalCode_idx" ON "public"."addresses"("city", "state", "postalCode");

-- CreateIndex
CREATE INDEX "addresses_latitude_longitude_idx" ON "public"."addresses"("latitude", "longitude");

-- CreateIndex
CREATE INDEX "companies_type_parent_id_idx" ON "public"."companies"("type", "parent_id");

-- CreateIndex
CREATE INDEX "batches_delivery_company_id_client_company_id_idx" ON "public"."batches"("delivery_company_id", "client_company_id");

-- CreateIndex
CREATE UNIQUE INDEX "batches_delivery_company_id_client_company_id_name_key" ON "public"."batches"("delivery_company_id", "client_company_id", "name");

-- CreateIndex
CREATE UNIQUE INDEX "batch_items_batch_id_company_id_key" ON "public"."batch_items"("batch_id", "company_id");

-- CreateIndex
CREATE UNIQUE INDEX "vehicles_plate_key" ON "public"."vehicles"("plate");

-- CreateIndex
CREATE INDEX "vehicles_company_id_idx" ON "public"."vehicles"("company_id");

-- CreateIndex
CREATE INDEX "deliveries_date_delivery_status_idx" ON "public"."deliveries"("date", "delivery_status");

-- CreateIndex
CREATE INDEX "deliveries_driver_id_vehicle_id_idx" ON "public"."deliveries"("driver_id", "vehicle_id");

-- CreateIndex
CREATE INDEX "stops_delivery_id_sequence_idx" ON "public"."stops"("delivery_id", "sequence");

-- CreateIndex
CREATE INDEX "stops_status_end_client_id_idx" ON "public"."stops"("status", "end_client_id");

-- AddForeignKey
ALTER TABLE "public"."users" ADD CONSTRAINT "users_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "public"."companies"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."users" ADD CONSTRAINT "users_vehicleId_fkey" FOREIGN KEY ("vehicleId") REFERENCES "public"."vehicles"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."companies" ADD CONSTRAINT "companies_address_id_fkey" FOREIGN KEY ("address_id") REFERENCES "public"."addresses"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."companies" ADD CONSTRAINT "companies_parent_id_fkey" FOREIGN KEY ("parent_id") REFERENCES "public"."companies"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."batches" ADD CONSTRAINT "batches_delivery_company_id_fkey" FOREIGN KEY ("delivery_company_id") REFERENCES "public"."companies"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."batches" ADD CONSTRAINT "batches_client_company_id_fkey" FOREIGN KEY ("client_company_id") REFERENCES "public"."companies"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."batches" ADD CONSTRAINT "batches_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "public"."companies"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."batch_items" ADD CONSTRAINT "batch_items_batch_id_fkey" FOREIGN KEY ("batch_id") REFERENCES "public"."batches"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."batch_items" ADD CONSTRAINT "batch_items_company_id_fkey" FOREIGN KEY ("company_id") REFERENCES "public"."companies"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."vehicles" ADD CONSTRAINT "vehicles_company_id_fkey" FOREIGN KEY ("company_id") REFERENCES "public"."companies"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."deliveries" ADD CONSTRAINT "deliveries_delivery_batch_id_fkey" FOREIGN KEY ("delivery_batch_id") REFERENCES "public"."batches"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."deliveries" ADD CONSTRAINT "deliveries_delivery_company_id_fkey" FOREIGN KEY ("delivery_company_id") REFERENCES "public"."companies"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."deliveries" ADD CONSTRAINT "deliveries_client_company_id_fkey" FOREIGN KEY ("client_company_id") REFERENCES "public"."companies"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."deliveries" ADD CONSTRAINT "deliveries_driver_id_fkey" FOREIGN KEY ("driver_id") REFERENCES "public"."users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."deliveries" ADD CONSTRAINT "deliveries_vehicle_id_fkey" FOREIGN KEY ("vehicle_id") REFERENCES "public"."vehicles"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."stops" ADD CONSTRAINT "stops_delivery_id_fkey" FOREIGN KEY ("delivery_id") REFERENCES "public"."deliveries"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."stops" ADD CONSTRAINT "stops_address_id_fkey" FOREIGN KEY ("address_id") REFERENCES "public"."addresses"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."stops" ADD CONSTRAINT "stops_end_client_id_fkey" FOREIGN KEY ("end_client_id") REFERENCES "public"."companies"("id") ON DELETE CASCADE ON UPDATE CASCADE;
