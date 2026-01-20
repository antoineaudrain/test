const { PrismaClient } = require('./src/generated/prisma');
const prisma = new PrismaClient();

async function debug() {
  // Get today in Paris timezone
  const now = new Date();
  const parisTime = new Date(now.toLocaleString('en-US', { timeZone: 'Europe/Paris' }));
  const today = new Date(parisTime.getFullYear(), parisTime.getMonth(), parisTime.getDate());

  console.log('Today (Paris timezone):', today);
  console.log('Today ISO:', today.toISOString());

  // Get all deliveries
  const allDeliveries = await prisma.delivery.findMany({
    select: {
      id: true,
      number: true,
      date: true,
      deliveryStatus: true,
      deliveryCompanyId: true,
    },
    orderBy: {
      date: 'desc'
    },
    take: 10
  });

  console.log('\nAll recent deliveries:');
  console.log(allDeliveries);

  // Get deliveries for today
  const todayDeliveries = await prisma.delivery.findMany({
    where: {
      date: today
    },
    select: {
      id: true,
      number: true,
      date: true,
      deliveryStatus: true,
    }
  });

  console.log('\nDeliveries for today:');
  console.log(todayDeliveries);

  await prisma.$disconnect();
}

debug().catch(console.error);