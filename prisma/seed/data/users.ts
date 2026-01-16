import { type Prisma, UserRole } from "@/generated/prisma";

type Company = Prisma.CompanyGetPayload<Record<string, never>>;
type UserInput = Prisma.UserCreateInput;

export type UserFactoryCallbackOptions = {
  company: Company;
};
export type UserFactory = (companies: Company[]) => UserInput[];
export type UserFactoryCallback = (
  options: UserFactoryCallbackOptions,
) => UserInput[];

export type UserConfig = {
  companyName: string;
};

export function createUserFactory(
  config: UserConfig,
  callback: UserFactoryCallback,
): UserFactory {
  return function userFactory(companies: Company[]): UserInput[] {
    const company = companies.find(
      (company) => company.name === config.companyName,
    );
    if (!company) throw new Error(`Company ${config.companyName} not found`);
    return callback({ company });
  };
}

export const USERS: UserFactory[] = [
  createUserFactory({ companyName: "Trans Dental Services" }, ({ company }) => [
    {
      externalId: "user_2zYJTzmaVUCbfIN66MN9qlSJ9Xa",
      email: "oudjedi.chabane@tds-transports.fr",
      firstName: "Oudjedi",
      lastName: "Chabane",
      role: UserRole.ADMIN,
      company: {
        connect: { id: company.id },
      },
      vehicle: {
        create: {
          model: "2025 Explorer EV",
          plate: "WW-887-GB",
          company: {
            connect: { id: company.id },
          },
        },
      },
    },
    {
      externalId: "user_31pgVb3VShRLcjzFRLNUei6JQn9",
      email: "bilel-du-73@hotmail.fr",
      firstName: "Bilel",
      lastName: "Mokrane",
      role: UserRole.MEMBER,
      company: {
        connect: { id: company.id },
      },
      vehicle: {
        create: {
          model: "2025 Explorer EV",
          plate: "WW-862-GB",
          company: {
            connect: { id: company.id },
          },
        },
      },
    },
  ]),
  createUserFactory({ companyName: "ADEIS" }, ({ company }) => [
    {
      externalId: "user_30gVjZQQJmrXuh0OAcT5keXGAhw",
      email: "m.culoma@adeis.org",
      firstName: "Maeva",
      lastName: "Culoma",
      role: UserRole.ADMIN,
      company: {
        connect: { id: company.id },
      },
    },
  ]),
];
