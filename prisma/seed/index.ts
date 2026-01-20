/**
 * Database Seed Script
 *
 * This script populates the database with sample data for development and testing.
 *
 * What gets seeded:
 * - 43 companies (1 delivery company, 1 client company, 41 end-client companies)
 * - 3 users (2 drivers with vehicles, 1 client admin)
 * - 5 deliveries with different statuses:
 *   - Today's scheduled delivery
 *   - Today's in-progress delivery (partially completed)
 *   - Tomorrow's scheduled delivery
 *   - Yesterday's completed delivery
 *   - Next week's scheduled delivery
 * - 2 delivery requests for future dates
 *
 * Usage:
 * - Development: npm run db:seed
 * - After schema changes: npm run db:migrate && npm run db:seed
 *
 * Warning: This script DELETES all existing data before seeding!
 */

import { PrismaClient } from "@/generated/prisma";
import { Time } from "@/lib/time";
import { COMPANIES } from "./data/companies";
import { DELIVERIES } from "./data/deliveries";
import { DELIVERY_REQUESTS } from "./data/deliveryRequests";
import { USERS } from "./data/users";

const prisma = new PrismaClient();

/**
 * Fixes deliveries that have null delivery numbers
 * This can happen due to migration issues or data inconsistencies
 */
async function fixDeliveriesWithNullNumbers() {
  console.log("🔧 Checking for deliveries with null numbers...");

  const deliveriesWithNullNumbers = await prisma.$queryRaw<
    Array<{ id: string; created_at: Date }>
  >`
    SELECT id, created_at
    FROM deliveries
    WHERE number IS NULL
    ORDER BY created_at
  `;

  if (deliveriesWithNullNumbers.length === 0) {
    console.log("✓ No deliveries with null numbers found");
    return;
  }

  console.log(
    `Found ${deliveriesWithNullNumbers.length} deliveries with null numbers, fixing...`,
  );

  const year = Time().format("YY");

  for (let i = 0; i < deliveriesWithNullNumbers.length; i++) {
    const delivery = deliveriesWithNullNumbers[i];

    // Get current count to generate unique sequence
    const count = await prisma.delivery.count({
      where: {
        number: { startsWith: `TDS${year}-` },
      },
    });

    const sequence = (count + i + 1).toString().padStart(4, "0");
    const deliveryNumber = `TDS${year}-${sequence}`;

    await prisma.$executeRaw`
      UPDATE deliveries
      SET number = ${deliveryNumber}
      WHERE id = ${delivery.id}
    `;
  }

  console.log("✓ Fixed all deliveries with null numbers");
}

/**
 * Clears all existing data from the database
 * CAUTION: This will delete all data!
 */
async function clearDatabase() {
  console.log("🗑️  Clearing existing data...");

  await prisma.$transaction([
    prisma.deliveryRequestStop.deleteMany(),
    prisma.deliveryRequest.deleteMany(),
    prisma.stop.deleteMany(),
    prisma.delivery.deleteMany(),
    prisma.user.deleteMany(),
    prisma.vehicle.deleteMany(),
    prisma.clientSettings.deleteMany(),
    prisma.company.deleteMany(),
    prisma.address.deleteMany(),
  ]);

  console.log("✓ Database cleared");
}

/**
 * Seeds the database with companies and their addresses
 */
async function seedCompanies() {
  console.log("🏢 Creating companies...");

  await Promise.all(
    COMPANIES.map((input) =>
      prisma.company.create({
        data: input,
      }),
    ),
  );

  const companies = await prisma.company.findMany({
    include: {
      address: true,
      clientCompanies: {
        include: {
          address: true,
        },
      },
    },
  });

  console.log(`✓ Created ${companies.length} companies`);

  return companies;
}

/**
 * Seeds the database with users and vehicles
 */
async function seedUsers(companies: Awaited<ReturnType<typeof seedCompanies>>) {
  console.log("👥 Creating users and vehicles...");

  await Promise.all(
    USERS.flatMap((generator) =>
      generator(companies).map((input) =>
        prisma.user.create({
          data: input,
        }),
      ),
    ),
  );

  const users = await prisma.user.findMany({
    include: { vehicle: true },
  });

  const usersWithVehicles = users.filter((u) => u.vehicle);

  console.log(
    `✓ Created ${users.length} users (${usersWithVehicles.length} with vehicles)`,
  );

  return users;
}

/**
 * Seeds the database with deliveries and stops
 */
async function seedDeliveries({
  companies,
  users,
}: {
  companies: Awaited<ReturnType<typeof seedCompanies>>;
  users: Awaited<ReturnType<typeof seedUsers>>;
}) {
  console.log("🚚 Creating deliveries...");

  const deliveryInputs = DELIVERIES.flatMap((factory) =>
    factory({ companies, users }),
  );

  if (deliveryInputs.length === 0) {
    console.warn("⚠️  No deliveries to create");
    return;
  }

  const deliveries = await Promise.all(
    deliveryInputs.map((input) => prisma.delivery.create({ data: input })),
  );

  // Get stop counts for each delivery
  const deliveriesWithStops = await prisma.delivery.findMany({
    include: {
      stops: true,
    },
  });

  const totalStops = deliveriesWithStops.reduce(
    (sum, d) => sum + d.stops.length,
    0,
  );

  console.log(
    `✓ Created ${deliveries.length} deliveries with ${totalStops} stops`,
  );

  return deliveries;
}

/**
 * Seeds the database with delivery requests
 */
async function seedDeliveryRequests({
  companies,
}: {
  companies: Awaited<ReturnType<typeof seedCompanies>>;
}) {
  console.log("📋 Creating delivery requests...");

  const deliveryRequestInputs = DELIVERY_REQUESTS.flatMap((factory) =>
    factory({ companies }),
  );

  if (deliveryRequestInputs.length === 0) {
    console.warn("⚠️  No delivery requests to create");
    return;
  }

  const deliveryRequests = await Promise.all(
    deliveryRequestInputs.map((input) =>
      prisma.deliveryRequest.create({ data: input }),
    ),
  );

  // Get stop counts for each delivery request
  const requestsWithStops = await prisma.deliveryRequest.findMany({
    include: {
      stops: true,
    },
  });

  const totalStops = requestsWithStops.reduce(
    (sum, r) => sum + r.stops.length,
    0,
  );

  console.log(
    `✓ Created ${deliveryRequests.length} delivery requests with ${totalStops} stops`,
  );

  return deliveryRequests;
}

/**
 * Main seed function
 */
async function main() {
  console.log("🌱 Starting database seeding...\n");

  try {
    // Fix any existing data issues
    await fixDeliveriesWithNullNumbers();

    // Clear the database
    await clearDatabase();

    // Seed data in order
    const companies = await seedCompanies();
    const users = await seedUsers(companies);
    await seedDeliveries({ companies, users });
    await seedDeliveryRequests({ companies });

    console.log("\n🎉 Seed completed successfully!");
  } catch (error) {
    console.error("\n❌ Seed failed:");
    throw error;
  }
}

main()
  .catch((error) => {
    console.error(error);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
