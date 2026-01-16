import type { Prisma } from "@/generated/prisma";

export type Employee = Prisma.UserGetPayload<{}>;

export type EmployeeIncludeOptions = Prisma.UserInclude;
export type EmployeeWithRelations<T extends EmployeeIncludeOptions> =
  Prisma.UserGetPayload<{ include: T }>;
