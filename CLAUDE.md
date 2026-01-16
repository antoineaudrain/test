# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

TDS Transports is a B2B delivery platform specializing in medical and dental transportation services. The application manages three types of companies: delivery companies (transporters), client companies (e.g., dental labs), and end-client companies (e.g., dentist offices). The platform handles delivery requests, route optimization, real-time tracking, and reporting.

## Tech Stack

- **Framework**: Next.js 15 with React 19, using App Router
- **Database**: PostgreSQL with Prisma ORM (client generated to `src/generated/prisma`)
- **Authentication**: Clerk (integrated with custom user management in database)
- **Styling**: Tailwind CSS (v4.x, uses PostCSS)
- **Code Quality**: Biome (replaces ESLint and Prettier)
- **Maps**: Mapbox GL for route visualization
- **Email**: Resend with React Email templates
- **Monitoring**: Sentry (tunnel route at `/monitoring`)
- **Storage**: AWS S3 for images
- **Time**: Day.js configured for Europe/Paris timezone

## Development Commands

```bash
# Development
npm run dev                 # Start dev server

# Database
npm run db:new <name>       # Create new migration
npm run db:migrate          # Run migrations (deploy)
npm run db:generate         # Generate Prisma client
npm run db:seed             # Seed database
npm run db:reset            # Reset database (dangerous!)
npm run db:status           # Check migration status
npm run db:rollback         # Rollback migration

# Code Quality
npm run lint                # Check with Biome
npm run format              # Format with Biome

# Build
npm run build               # Production build
npm run start               # Start production server
```

## Project Architecture

### Directory Structure

```
src/
├── app/                    # Next.js App Router
│   ├── (app)/             # Authenticated app layout
│   ├── (marketing)/       # Public marketing pages
│   ├── api/               # API routes (limited use)
│   ├── sign-in/           # Clerk auth pages
│   └── sign-up/
├── features/              # Feature-based modules
│   ├── deliveries/
│   │   ├── actions/       # Server actions
│   │   │   ├── mutations/ # Data-modifying actions
│   │   │   └── queries/   # Data-fetching actions
│   │   ├── components/    # UI components
│   │   ├── schema/        # Zod validation schemas
│   │   └── types/         # TypeScript types
│   ├── batches/
│   ├── clients/
│   ├── employees/
│   ├── stops/
│   ├── vehicles/
│   ├── emails/
│   ├── reporting/
│   └── shared/            # Shared components and helpers
├── lib/                   # Core utilities
│   ├── database/          # Prisma client
│   ├── permissions/       # Auth context and policies
│   ├── time/              # Time utilities (Day.js)
│   ├── mapbox/            # Map utilities
│   ├── storage/           # S3 utilities
│   ├── email/             # Email client
│   └── waybill/           # PDF generation
└── generated/
    └── prisma/            # Generated Prisma client
```

### Feature Module Pattern

Each feature follows a consistent structure:
- **actions/mutations/** - Server actions that modify data (`"use server"`)
- **actions/queries/** - Server actions that fetch data (`"use server"`)
- **components/** - React components (client or server)
- **schema/** - Zod schemas for form validation
- **types/** - TypeScript type definitions using Prisma types

### Server Actions Pattern

All database operations use server actions (not API routes, except for special cases). Server actions are wrapped with `withAuth()` for authentication and authorization:

```typescript
"use server";

import { withAuth } from "@/lib/permissions";
import prisma from "@/lib/database/prisma";

export async function getDelivery({ deliveryId }: { deliveryId: string }) {
  return withAuth(async (ctx, policies) => {
    // ctx contains: user, company, vehicle
    // policies contains: authorization methods

    const delivery = await prisma.delivery.findFirst({
      where: { id: deliveryId },
      include: { /* relations */ }
    });

    if (!delivery) throw new Error("Delivery not found");
    policies.canViewDelivery(delivery); // Check permissions

    return delivery;
  });
}
```

### Authentication & Authorization

**Context (`ctx`):**
- `ctx.user` - Current user (without company/vehicle)
- `ctx.company` - User's company with `parentCompany` relation
- `ctx.vehicle` - Driver's vehicle (if applicable)

**Policies (`policies`):**
The `Policies` class (in `src/lib/permissions/policies.ts`) contains all authorization logic:
- Company type checks: `isDeliveryCompany()`, `isClientCompany()`, `isEndClientCompany()`
- Role checks: `isAdmin()`, `isManager()`, `isMember()`, `isDriver()`
- Permission checks: `canViewDelivery()`, `canUpdateDelivery()`, etc.
- Throws `PolicyError` on authorization failures

**Page-level guards:**
Use `requireAuth()` and `requirePermission()` in page components:
```typescript
await requireAuth();
await requirePermission((policies) => policies.canViewDeliveryListPage());
```

### Database Schema

**Key Models:**
- **User** - Authenticated users with roles (ADMIN, MANAGER, MEMBER)
- **Company** - Three types: DELIVERY, CLIENT, END_CLIENT (hierarchical: DELIVERY > CLIENT > END_CLIENT)
- **Vehicle** - Vehicles owned by delivery companies
- **Delivery** - Main delivery entity with request/delivery status workflow
- **Stop** - Individual stops within a delivery (pickup/dropoff)
- **Address** - Geocoded addresses with lat/lng
- **Batch** - (Being removed in current branch)

**Key Enums:**
- `UserRole`: ADMIN, MANAGER, MEMBER
- `CompanyType`: DELIVERY, CLIENT, END_CLIENT
- `RequestStatus`: PENDING, ACCEPTED, DECLINED, EXPIRED
- `DeliveryStatus`: SCHEDULED, IN_PROGRESS, COMPLETED, CANCELLED
- `StopStatus`: PLANNED, EN_ROUTE, DELIVERED, FAILED

### Type Definitions

Types are derived from Prisma models using helper types:

```typescript
import type { Prisma } from "@/generated/prisma";

export type Delivery = Prisma.DeliveryGetPayload<{}>;

export type DeliveryIncludeOptions = Prisma.DeliveryInclude;
export type DeliveryWithRelations<T extends DeliveryIncludeOptions> =
  Prisma.DeliveryGetPayload<{ include: T }>;
```

This pattern allows type-safe queries with included relations.

### Time Handling

All time operations use Day.js configured for Europe/Paris timezone. Import from `@/lib/time`:

```typescript
import { Time, dateStringToDate, now, formatDateString, startOfToday } from "@/lib/time";

// Day.js instance with timezone and French locale
const today = Time();

// Convert date string (YYYY-MM-DD) to Date object in Paris timezone
const date = dateStringToDate("2024-01-15");

// Get current Date in Paris timezone
const currentDate = now();
```

Never use `new Date()` directly - always use the time utilities to ensure correct timezone handling.

### Form Validation

Forms use Zod schemas for validation, stored in each feature's `schema/` directory:

```typescript
import { z } from "zod";

export const CreateDeliveryFormSchema = z.object({
  date: z.string().min(1, "Date is required"),
  notes: z.string().optional(),
  stops: z.array(/* ... */),
});

export type CreateDeliveryFormInput = z.infer<typeof CreateDeliveryFormSchema>;
```

### Email Notifications

Email templates use React Email components in `src/features/emails/templates/`:

```typescript
import { sendNotificationEmail } from "@/features/emails/actions/sendNotificationEmail";
import { DeliveryCreatedNotification } from "@/features/emails/templates/DeliveryCreatedNotification";

await sendNotificationEmail({
  subject: "Delivery Created",
  template: DeliveryCreatedNotification({ /* props */ }),
  meta: { source: "delivery-system", type: "delivery-created" }
});
```

### API Routes

Most operations use server actions. API routes (`src/app/api/`) are only used for:
- Clerk webhooks
- Image uploads
- Special integrations

API routes can use `withAuth()` wrapper for authentication:

```typescript
export const POST = async (req: Request) => {
  return withAuth(async (ctx, policies) => {
    // Handle request
    return NextResponse.json(result);
  });
};
```

## Important Patterns & Conventions

### Path Aliases

Use `@/*` for imports from `src/`:
```typescript
import prisma from "@/lib/database/prisma";
import { withAuth } from "@/lib/permissions";
import type { Delivery } from "@/features/deliveries/types";
```

### Prisma Client

Always import from the generated location:
```typescript
import prisma from "@/lib/database/prisma";
import { DeliveryStatus, RequestStatus } from "@/generated/prisma";
import type { Prisma } from "@/generated/prisma";
```

### Error Handling

- Use `PolicyError` for authorization failures
- Use regular `Error` for validation and business logic failures
- Server actions catch errors and can be handled by error boundaries

### Cache Revalidation

Use Next.js cache revalidation after mutations:
```typescript
import { revalidatePath } from "next/cache";

// After mutation
revalidatePath("/deliveries");
revalidatePath(`/deliveries/${delivery.id}`);
```

### SVG Imports

SVGs can be imported as React components or URLs:
```typescript
import Logo from "@/assets/logo.svg";           // As component
import logoUrl from "@/assets/logo.svg?url";    // As URL
```

## Common Workflows

### Adding a New Feature

1. Create feature directory in `src/features/[feature-name]/`
2. Add actions (mutations and queries) with server actions
3. Add Zod schemas for validation
4. Add TypeScript types derived from Prisma
5. Create React components
6. Add page in `src/app/(app)/[feature-name]/`
7. Add policies to `src/lib/permissions/policies.ts`
8. Update page guards if needed

### Modifying Database Schema

1. Update `prisma/schema.prisma`
2. Run `npm run db:new <migration-name>` to create migration
3. Run `npm run db:generate` to update Prisma client
4. Update types in relevant feature directories
5. Update seed data if needed in `prisma/seed/`

### Testing Permissions

1. Check company types: `policies.isDeliveryCompany()`, etc.
2. Check roles: `policies.isAdmin()`, etc.
3. Check specific permissions: `policies.canViewDelivery(delivery)`
4. Add new policies to `Policies` class if needed

## Current Branch Context

The `feat/remove-batch` branch is removing batch-related logic from the delivery system. Deliveries are now created directly without batch associations. Be aware that batch references may still exist in some parts of the codebase during this transition.