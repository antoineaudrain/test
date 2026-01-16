"use server";

import { clerkClient } from "@clerk/nextjs/server";
import { revalidatePath } from "next/cache";
import { redirect } from "next/navigation";
import type { CreateCompanyFormInput } from "@/features/clients/schemas/createCompany";
import {
  CreateClientCompanyFormSchema,
  CreateCompanyFormSchema,
} from "@/features/clients/schemas/createCompany";
import { sendNotificationEmail } from "@/features/emails/actions/sendNotificationEmail";
import { AccountActivationNotification } from "@/features/emails/templates/AccountActivationNotification";
import { CompanyType, UserRole } from "@/generated/prisma";
import prisma from "@/lib/database/prisma";
import { withAuth } from "@/lib/permissions";

type CreateCompanyProps = {
  input: CreateCompanyFormInput;
};

export async function createCompany({
  input,
}: CreateCompanyProps): Promise<void> {
  return withAuth<void>(async (ctx, policies) => {
    policies.canCreateCompany();

    let companyType: CompanyType;
    let validatedInput: CreateCompanyFormInput;

    if (ctx.company.type === CompanyType.DELIVERY) {
      policies.canCreateClientCompany();
      companyType = CompanyType.CLIENT;
      validatedInput = CreateClientCompanyFormSchema.parse(input);
    } else if (ctx.company.type === CompanyType.CLIENT) {
      policies.canCreateEndClientCompany();
      companyType = CompanyType.END_CLIENT;
      validatedInput = CreateCompanyFormSchema.parse(input);
    } else {
      throw new Error("Invalid company type for creation");
    }

    const {
      address: addressInput,
      ownerEmail,
      ownerFirstName,
      ownerLastName,
      ...companyInput
    } = validatedInput;

    if (
      companyType === CompanyType.CLIENT &&
      (!ownerEmail || !ownerFirstName || !ownerLastName)
    ) {
      throw new Error("Owner information is required for client companies");
    }

    let clerkUserId: string | undefined;

    try {
      if (companyType === CompanyType.CLIENT) {
        const existingUser = await prisma.user.findUnique({
          where: { email: ownerEmail },
        });

        if (existingUser) {
          throw new Error("Un utilisateur avec cet email existe déjà");
        }

        if (!ownerEmail || !ownerFirstName || !ownerLastName) {
          throw new Error(
            "Owner information is required when creating an account",
          );
        }

        const clerk = await clerkClient();
        const clerkUser = await clerk.users.createUser({
          emailAddress: [ownerEmail],
          firstName: ownerFirstName,
          lastName: ownerLastName,
          skipPasswordRequirement: true,
          skipPasswordChecks: true,
        });

        clerkUserId = clerkUser.id;

        const signInToken = await clerk.signInTokens.createSignInToken({
          userId: clerkUser.id,
          expiresInSeconds: 86400,
        });

        const baseUrl =
          process.env.NEXT_PUBLIC_APP_URL || "https://app.tds-transports.fr";
        const activationUrl = `${baseUrl}/sign-in?ticket=${signInToken.token}`;

        await sendNotificationEmail({
          email: ownerEmail,
          subject: "Activez votre compte TDS Transports",
          template: AccountActivationNotification({
            firstName: ownerFirstName,
            lastName: ownerLastName,
            companyName: companyInput.name,
            activationUrl,
          }),
          meta: {
            source: "company-creation",
            type: "account-activation",
            priority: "high",
            userId: clerkUser.id,
          },
        });
      }

      const company = await prisma.company.create({
        data: {
          name: companyInput.name,
          type: companyType,
          parentCompany: {
            connect: { id: ctx.company.id },
          },
          address: {
            create: addressInput,
          },
          ...(clerkUserId && {
            users: {
              create: {
                externalId: clerkUserId,
                email: ownerEmail!,
                firstName: ownerFirstName!,
                lastName: ownerLastName!,
                role: UserRole.ADMIN,
              },
            },
          }),
        },
        include: { address: true },
      });

      // Create client settings if cutoffTime is provided
      if (
        companyType === CompanyType.CLIENT &&
        "cutoffTime" in validatedInput
      ) {
        const { cutoffTime } = validatedInput as { cutoffTime?: string | null };
        if (cutoffTime) {
          await prisma.clientSettings.create({
            data: {
              clientCompanyId: company.id,
              cutoffTime,
            },
          });
        }
      }

      revalidatePath("/clients");
      revalidatePath(`/clients/${company.id}`);
      redirect("/clients");
    } catch (error) {
      if (clerkUserId) {
        try {
          const clerk = await clerkClient();
          await clerk.users.deleteUser(clerkUserId);
        } catch (cleanupError) {
          console.error("Failed to cleanup Clerk user:", cleanupError);
        }
      }

      if (error instanceof Error) {
        throw error;
      }
      throw new Error("Échec de la création de l'entreprise");
    }
  });
}
