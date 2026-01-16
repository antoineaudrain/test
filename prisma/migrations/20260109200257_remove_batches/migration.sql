-- AlterTable: Make batch_name nullable (for new deliveries)
ALTER TABLE "deliveries" ALTER COLUMN "batch_name" DROP NOT NULL;

-- DropForeignKey
ALTER TABLE "deliveries" DROP CONSTRAINT IF EXISTS "deliveries_delivery_batch_id_fkey";

-- DropForeignKey
ALTER TABLE "batch_items" DROP CONSTRAINT IF EXISTS "batch_items_batch_id_fkey";

-- DropForeignKey
ALTER TABLE "batch_items" DROP CONSTRAINT IF EXISTS "batch_items_company_id_fkey";

-- DropForeignKey
ALTER TABLE "batches" DROP CONSTRAINT IF EXISTS "batches_delivery_company_id_fkey";

-- DropForeignKey
ALTER TABLE "batches" DROP CONSTRAINT IF EXISTS "batches_client_company_id_fkey";

-- DropForeignKey
ALTER TABLE "batches" DROP CONSTRAINT IF EXISTS "batches_driver_id_fkey";

-- DropForeignKey (orphaned relation from schema)
ALTER TABLE "batches" DROP CONSTRAINT IF EXISTS "batches_companyId_fkey";

-- DropTable
DROP TABLE "batch_items";

-- DropTable
DROP TABLE "batches";

-- AlterTable: Remove delivery_batch_id column
ALTER TABLE "deliveries" DROP COLUMN "delivery_batch_id";
