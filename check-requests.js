const { PrismaClient } = require("./src/generated/prisma");
const prisma = new PrismaClient();

async function check() {
  const requests = await prisma.deliveryRequest.findMany({
    include: {
      stops: true,
      clientCompany: {
        select: { name: true },
      },
      deliveryCompany: {
        select: { name: true },
      },
    },
    orderBy: {
      date: "desc",
    },
  });

  console.log(`Found ${requests.length} delivery requests:\n`);
  requests.forEach((req) => {
    console.log(
      `- ${req.date.toISOString().split("T")[0]} | ${req.clientCompany.name} → ${req.deliveryCompany.name} | ${req.stops.length} stops`,
    );
  });

  await prisma.$disconnect();
}

check().catch(console.error);
