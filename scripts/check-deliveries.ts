import prisma from "../src/lib/database/prisma";

async function check() {
  const all = await prisma.delivery.findMany({
    select: { id: true, number: true, createdAt: true },
  });

  console.log(`Total deliveries: ${all.length}`);

  const withNull = all.filter((d) => d.number === null);
  console.log(`Deliveries with null number: ${withNull.length}`);

  if (withNull.length > 0) {
    console.log("Deliveries with null numbers:");
    withNull.forEach((d) =>
      console.log(`  - ID: ${d.id}, created: ${d.createdAt}`),
    );
  } else {
    console.log("✓ All deliveries have valid numbers!");
  }
}

check()
  .catch(console.error)
  .finally(() => prisma.$disconnect());
