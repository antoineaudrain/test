import { RedirectToSignIn, SignedIn, SignedOut } from "@clerk/nextjs";
import type { PropsWithChildren } from "react";
import { AppLayout } from "@/app/(app)/AppLayout";
import { checkPermission, type Policies } from "@/lib/permissions";

export const dynamic = "force-dynamic";

export default async function RootLayout({ children }: PropsWithChildren) {
  const permissionsToCheck = {
    canViewDeliveryListPage: (policies: Policies) =>
      policies.canViewDeliveryListPage(),
    canViewDeliveryRequestListPage: (policies: Policies) =>
      policies.canViewDeliveryRequestListPage(),
    canViewVehicleListPage: (policies: Policies) =>
      policies.canViewVehicleListPage(),
    canViewEmployeeListPage: (policies: Policies) =>
      policies.canViewEmployeeListPage(),
    canViewClientListPage: (policies: Policies) =>
      policies.canViewClientListPage(),
    canViewReportingPage: (policies: Policies) =>
      policies.canViewReportingPage(),
  };

  const results = await Promise.all(
    Object.entries(permissionsToCheck).map(async ([key, fn]) => {
      const { hasPermission } = await checkPermission(fn);
      return [key, hasPermission] as const;
    }),
  );

  const {
    canViewDeliveryListPage,
    canViewDeliveryRequestListPage,
    canViewVehicleListPage,
    canViewEmployeeListPage,
    canViewClientListPage,
    canViewReportingPage,
  } = Object.fromEntries(results);

  const permissions = {
    canViewDeliveryListPage,
    canViewDeliveryRequestListPage,
    canViewVehicleListPage,
    canViewEmployeeListPage,
    canViewClientListPage,
    canViewReportingPage,
  };

  return (
    <>
      <SignedOut>
        <RedirectToSignIn />
      </SignedOut>

      <SignedIn>
        <AppLayout permissions={permissions}>{children}</AppLayout>
      </SignedIn>
    </>
  );
}
