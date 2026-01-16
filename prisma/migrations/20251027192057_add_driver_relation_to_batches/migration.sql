-- AlterTable
ALTER TABLE "batches" ADD COLUMN     "driver_id" TEXT;

-- AddForeignKey
ALTER TABLE "batches" ADD CONSTRAINT "batches_driver_id_fkey" FOREIGN KEY ("driver_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
