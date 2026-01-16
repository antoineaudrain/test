import { PrismaClient } from "@/generated/prisma";
import { COMPANIES } from "./data/companies";
import { DELIVERIES } from "./data/deliveries";
import { USERS } from "./data/users";

const prisma = new PrismaClient();

async function main() {
  console.log("🌱 Starting database seeding...");

  await prisma.$transaction([
    prisma.stop.deleteMany(),
    prisma.delivery.deleteMany(),
    prisma.user.deleteMany(),
    prisma.vehicle.deleteMany(),
    prisma.company.deleteMany(),
    prisma.address.deleteMany(),
  ]);

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

  console.log("👥 Creating users...");
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

  console.log("🚚 Creating deliveries...");
  const _deliveries = await Promise.all(
    DELIVERIES.flatMap((factory) => factory({ companies, users })).map(
      (input) => prisma.delivery.create({ data: input }),
    ),
  );

  console.log("🎉 Seed completed!");
}

main()
  .catch(console.error)
  .finally(() => prisma.$disconnect());
