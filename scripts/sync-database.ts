#!/usr/bin/env tsx

import prompts from "prompts";
import { PrismaClient } from "@/generated/prisma";

async function main() {
  // Prompt for remote database URL
  const response = await prompts({
    type: "text",
    name: "url",
    message: "Enter the remote database URL:",
    validate: (value) =>
      value.startsWith("postgresql://") ||
      value.startsWith("postgres://") ||
      "Please enter a valid PostgreSQL connection string",
  });

  if (!response.url) {
    console.log("❌ Operation cancelled");
    process.exit(0);
  }

  // Confirm operation
  const confirm = await prompts({
    type: "confirm",
    name: "value",
    message:
      "⚠️  This will DELETE all local data and replace it with remote data. Continue?",
    initial: false,
  });

  if (!confirm.value) {
    console.log("❌ Operation cancelled");
    process.exit(0);
  }

  console.log("\n🔄 Starting database sync...\n");

  // Connect to remote database
  const remotePrisma = new PrismaClient({
    datasources: { db: { url: response.url } },
  });

  // Connect to local database
  const localPrisma = new PrismaClient();

  try {
    // Fetch all data from remote
    console.log("📥 Fetching data from remote database...");
    const [
      addresses,
      companies,
      vehicles,
      users,
      deliveries,
      stops,
      deliveryRequests,
      deliveryRequestStops,
      clientSettings,
    ] = await Promise.all([
      remotePrisma.address.findMany(),
      remotePrisma.company.findMany(),
      remotePrisma.vehicle.findMany(),
      remotePrisma.user.findMany(),
      remotePrisma.delivery.findMany(),
      remotePrisma.stop.findMany(),
      remotePrisma.deliveryRequest.findMany(),
      remotePrisma.deliveryRequestStop.findMany(),
      remotePrisma.clientSettings.findMany(),
    ]);

    console.log("✅ Fetched remote data:");
    console.log(`   - ${addresses.length} addresses`);
    console.log(`   - ${companies.length} companies`);
    console.log(`   - ${vehicles.length} vehicles`);
    console.log(`   - ${users.length} users`);
    console.log(`   - ${deliveries.length} deliveries`);
    console.log(`   - ${stops.length} stops`);
    console.log(`   - ${deliveryRequests.length} delivery requests`);
    console.log(`   - ${deliveryRequestStops.length} delivery request stops`);
    console.log(`   - ${clientSettings.length} client settings\n`);

    // Clear local database (reverse dependency order)
    console.log("🗑️  Clearing local database...");
    await localPrisma.$transaction([
      localPrisma.clientSettings.deleteMany(),
      localPrisma.deliveryRequestStop.deleteMany(),
      localPrisma.deliveryRequest.deleteMany(),
      localPrisma.stop.deleteMany(),
      localPrisma.delivery.deleteMany(),
      localPrisma.user.deleteMany(),
      localPrisma.vehicle.deleteMany(),
      localPrisma.company.deleteMany(),
      localPrisma.address.deleteMany(),
    ]);
    console.log("✅ Local database cleared\n");

    // Insert data into local database (dependency order)
    console.log("📤 Inserting data into local database...");
    await localPrisma.$transaction(async (tx) => {
      // Insert addresses first (no dependencies)
      if (addresses.length > 0) {
        await tx.address.createMany({ data: addresses });
        console.log(`   ✓ Inserted ${addresses.length} addresses`);
      }

      // Insert companies (depends on addresses)
      if (companies.length > 0) {
        await tx.company.createMany({ data: companies });
        console.log(`   ✓ Inserted ${companies.length} companies`);
      }

      // Insert vehicles (depends on companies)
      if (vehicles.length > 0) {
        await tx.vehicle.createMany({ data: vehicles });
        console.log(`   ✓ Inserted ${vehicles.length} vehicles`);
      }

      // Insert users (depends on companies and vehicles)
      if (users.length > 0) {
        await tx.user.createMany({ data: users });
        console.log(`   ✓ Inserted ${users.length} users`);
      }

      // Insert deliveries (depends on companies, users, vehicles)
      if (deliveries.length > 0) {
        await tx.delivery.createMany({ data: deliveries });
        console.log(`   ✓ Inserted ${deliveries.length} deliveries`);
      }

      // Insert delivery requests (depends on companies)
      if (deliveryRequests.length > 0) {
        await tx.deliveryRequest.createMany({ data: deliveryRequests });
        console.log(
          `   ✓ Inserted ${deliveryRequests.length} delivery requests`,
        );
      }

      // Insert stops (depends on deliveries, addresses, companies)
      if (stops.length > 0) {
        await tx.stop.createMany({ data: stops });
        console.log(`   ✓ Inserted ${stops.length} stops`);
      }

      // Insert delivery request stops (depends on requests, addresses, companies, stops)
      if (deliveryRequestStops.length > 0) {
        await tx.deliveryRequestStop.createMany({ data: deliveryRequestStops });
        console.log(
          `   ✓ Inserted ${deliveryRequestStops.length} delivery request stops`,
        );
      }

      // Insert client settings (depends on companies)
      if (clientSettings.length > 0) {
        await tx.clientSettings.createMany({ data: clientSettings });
        console.log(`   ✓ Inserted ${clientSettings.length} client settings`);
      }
    });

    console.log("\n✅ Database sync completed successfully!");
  } catch (error) {
    console.error("\n❌ Error during sync:", error);
    process.exit(1);
  } finally {
    await remotePrisma.$disconnect();
    await localPrisma.$disconnect();
  }
}

main();
