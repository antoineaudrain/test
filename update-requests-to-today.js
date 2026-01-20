const { PrismaClient } = require("./src/generated/prisma");
const prisma = new PrismaClient();

async function updateToToday() {
  const now = new Date();
  const parisTime = new Date(
    now.toLocaleString("en-US", { timeZone: "Europe/Paris" }),
  );
  const today = new Date(
    parisTime.getFullYear(),
    parisTime.getMonth(),
    parisTime.getDate(),
  );

  console.log("Updating delivery requests to today:", today.toISOString());

  const result = await prisma.deliveryRequest.updateMany({
    where: {
      date: new Date("2026-01-18T00:00:00.000Z"),
    },
    data: {
      date: today,
    },
  });

  console.log(`Updated ${result.count} delivery requests`);

  const updated = await prisma.deliveryRequest.findMany({
    where: { date: today },
    include: {
      clientCompany: { select: { name: true } },
      stops: { select: { id: true } },
    },
  });

  console.log("\nDelivery requests for today:");
  updated.forEach((req) => {
    console.log(`- ${req.clientCompany.name} | ${req.stops.length} stops`);
  });

  await prisma.$disconnect();
}

updateToToday().catch(console.error);
