import prisma from "../src/lib/database/prisma";

async function fixNullDeliveryNumbers() {
  console.log("🔧 Checking for deliveries with null numbers...");

  const deliveriesWithNullNumbers = await prisma.$queryRaw<
    Array<{ id: string; created_at: Date }>
  >`
    SELECT id, created_at
    FROM deliveries
    WHERE number IS NULL
    ORDER BY created_at
  `;

  console.log(
    `Found ${deliveriesWithNullNumbers.length} deliveries with null numbers`,
  );

  if (deliveriesWithNullNumbers.length === 0) {
    console.log("✓ No deliveries to fix!");
    return;
  }

  console.log("Fixing deliveries...");

  for (let i = 0; i < deliveriesWithNullNumbers.length; i++) {
    const delivery = deliveriesWithNullNumbers[i];
    const year = new Date().getFullYear().toString().slice(-2);

    // Get current count to generate unique sequence
    const count = await prisma.delivery.count({
      where: {
        number: { startsWith: `TDS${year}-` },
      },
    });

    const sequence = (count + i + 1).toString().padStart(4, "0");
    const deliveryNumber = `TDS${year}-${sequence}`;

    console.log(`  Updating delivery ${delivery.id} → ${deliveryNumber}`);

    await prisma.$executeRaw`
      UPDATE deliveries
      SET number = ${deliveryNumber}
      WHERE id = ${delivery.id}
    `;
  }

  console.log(`✓ Fixed ${deliveriesWithNullNumbers.length} deliveries!`);
}

fixNullDeliveryNumbers()
  .catch((error) => {
    console.error("❌ Error:", error);
    process.exit(1);
  })
  .finally(() => {
    prisma.$disconnect();
  });
