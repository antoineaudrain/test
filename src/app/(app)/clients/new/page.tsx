import { ChevronLeftIcon } from "lucide-react";
import type { Metadata } from "next";
import { CreateCompanyForm } from "@/features/clients/components/CreateCompanyForm";
import { Heading, Link } from "@/features/shared/components";
import { CompanyType } from "@/generated/prisma";
import { getContext, requirePermission } from "@/lib/permissions";

export const metadata: Metadata = {
  title: "Nouvelle Entreprise",
  description: "Créer une nouvelle entreprise",
};

export default async function NewCompanyPage() {
  await requirePermission((policies) => policies.canViewClientNewPage());

  const ctx = await getContext();

  const config = {
    [CompanyType.DELIVERY]: {
      title: "Créer un Client",
      label: "Client",
      requiresOwner: true,
    },
    [CompanyType.CLIENT]: {
      title: "Créer un Client Final",
      label: "Client Final",
      requiresOwner: false,
    },
  };

  const pageConfig = config[ctx.company.type as keyof typeof config];

  if (!pageConfig) {
    throw new Error("Type d'entreprise non autorisé");
  }

  return (
    <>
      <div className="max-lg:hidden">
        <Link
          href="/clients"
          className="inline-flex items-center gap-2 text-sm/6 text-zinc-500 dark:text-zinc-400"
        >
          <ChevronLeftIcon className="size-4 text-zinc-400 dark:text-zinc-500" />
          Retour
        </Link>
      </div>

      <div className="flex flex-col gap-3 lg:gap-6">
        <div className="flex flex-wrap items-end justify-between gap-4">
          <div className="flex items-center gap-4">
            <Heading>{pageConfig.title}</Heading>
          </div>
        </div>

        <CreateCompanyForm
          companyTypeLabel={pageConfig.label}
          requiresOwner={pageConfig.requiresOwner}
        />
      </div>
    </>
  );
}
