import { neon } from "@neondatabase/serverless";

const SOURCE_DB_URL =
  "postgresql://neondb_owner:npg_0tPdHCpkOZK6@ep-steep-morning-a2mboik3-pooler.eu-central-1.aws.neon.tech/neondb?sslmode=require&channel_binding=require";
const TARGET_DB_URL =
  "postgresql://neondb_owner:npg_6XpHaUd0SRJT@ep-jolly-bird-a2ilqg4a-pooler.eu-central-1.aws.neon.tech/neondb?sslmode=require&channel_binding=require";

const source = neon(SOURCE_DB_URL);
const target = neon(TARGET_DB_URL);

async function migrateTable(tableName: string, columns: string[]) {
  console.log(`\nMigrating ${tableName}...`);

  // Use proper tagged template literal
  const rows = await source`SELECT * FROM ${source.unsafe(tableName)}`;
  console.log(`Found ${rows.length} rows`);

  if (rows.length === 0) return;

  // Quote column names for case-sensitivity
  const columnList = columns.map((col) => `"${col}"`).join(", ");
  const placeholders = columns.map((_, i) => `$${i + 1}`).join(", ");

  // Use .query() method for parameterized INSERT
  for (const row of rows) {
    const values = columns.map((col) => row[col]);
    await target.query(
      `INSERT INTO ${tableName} (${columnList})
       VALUES (${placeholders})
           ON CONFLICT (id) DO NOTHING`,
      values,
    );
  }

  console.log(`✓ Migrated ${rows.length} rows to ${tableName}`);
}

async function migrate() {
  try {
    console.log("Starting migration...\n");

    // Migrate in order of dependencies (parent tables first)
    await migrateTable("addresses", [
      "id",
      "externalId",
      "address",
      "city",
      "state",
      "postalCode",
      "country",
      "formattedAddress",
      "latitude",
      "longitude",
      "created_at",
      "updated_at",
    ]);

    await migrateTable("companies", [
      "id",
      "name",
      "type",
      "address_id",
      "parent_id",
      "created_at",
      "updated_at",
    ]);

    await migrateTable("vehicles", [
      "id",
      "plate",
      "model",
      "company_id",
      "created_at",
      "updated_at",
    ]);

    await migrateTable("users", [
      "id",
      "email",
      "external_id",
      "first_name",
      "last_name",
      "role",
      "companyId",
      "vehicleId",
      "created_at",
      "updated_at",
    ]);

    console.log("\n✅ Migration completed successfully!");
  } catch (error) {
    console.error("\n❌ Migration failed:", error);
    process.exit(1);
  }
}

migrate();
