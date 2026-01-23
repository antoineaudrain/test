/*
  Warnings:

  - You are about to drop the column `batch_name` on the `deliveries` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "addresses" ALTER COLUMN "externalId" DROP NOT NULL,
ALTER COLUMN "latitude" DROP NOT NULL,
ALTER COLUMN "longitude" DROP NOT NULL;

-- AlterTable
ALTER TABLE "deliveries" DROP COLUMN "batch_name";
