"use client";

import { UserButton } from "@clerk/clerk-react";
import {
  BarChartBigIcon,
  BriefcaseBusinessIcon,
  ClipboardListIcon,
  MapPinnedIcon,
  TruckElectricIcon,
  UsersIcon,
} from "lucide-react";
import { usePathname } from "next/navigation";
import type { PropsWithChildren } from "react";
import Logo from "@/assets/logo.svg";
import {
  Navbar,
  NavbarSection,
  NavbarSpacer,
  Sidebar,
  SidebarBody,
  SidebarFooter,
  SidebarHeader,
  SidebarItem,
  SidebarLabel,
  SidebarLayout,
  SidebarSection,
  SidebarSpacer,
} from "@/features/shared/components";
import { ThemeToggler } from "@/features/shared/components/ThemeToggler";

type AppLayoutProps = PropsWithChildren<{
  permissions?: {
    canViewDeliveryListPage: boolean;
    canViewDeliveryRequestListPage: boolean;
    canViewVehicleListPage: boolean;
    canViewEmployeeListPage: boolean;
    canViewClientListPage: boolean;
    canViewReportingPage: boolean;
  };
}>;

export function AppLayout({ permissions, children }: AppLayoutProps) {
  const pathname = usePathname();

  return (
    <SidebarLayout
      navbar={
        <Navbar>
          <NavbarSpacer />
          <NavbarSection>
            <UserButton />
          </NavbarSection>
        </Navbar>
      }
      sidebar={
        <Sidebar>
          <SidebarHeader>
            <Logo className="mr-auto h-8 w-auto px-2" />
          </SidebarHeader>

          <SidebarBody>
            <SidebarSection>
              {permissions?.canViewDeliveryListPage && (
                <SidebarItem
                  href="/deliveries"
                  current={pathname.startsWith("/deliveries")}
                >
                  <MapPinnedIcon className="h-5 w-5" />
                  <SidebarLabel>Livraisons</SidebarLabel>
                </SidebarItem>
              )}
              {permissions?.canViewDeliveryRequestListPage && (
                <SidebarItem
                  href="/delivery-requests"
                  current={pathname.startsWith("/delivery-requests")}
                >
                  <ClipboardListIcon className="h-5 w-5" />
                  <SidebarLabel>Demandes de livraison</SidebarLabel>
                </SidebarItem>
              )}
              {permissions?.canViewVehicleListPage && (
                <SidebarItem
                  href="/vehicles"
                  current={pathname.startsWith("/vehicles")}
                >
                  <TruckElectricIcon className="h-5 w-5" />
                  <SidebarLabel>Vehicules</SidebarLabel>
                </SidebarItem>
              )}
              {permissions?.canViewEmployeeListPage && (
                <SidebarItem
                  href="/employees"
                  current={pathname.startsWith("/employees")}
                >
                  <UsersIcon className="h-5 w-5" />
                  <SidebarLabel>Collaborateurs</SidebarLabel>
                </SidebarItem>
              )}
              {permissions?.canViewClientListPage && (
                <SidebarItem
                  href="/clients"
                  current={pathname.startsWith("/clients")}
                >
                  <BriefcaseBusinessIcon className="h-5 w-5" />
                  <SidebarLabel>Clients</SidebarLabel>
                </SidebarItem>
              )}
              {permissions?.canViewReportingPage && (
                <SidebarItem
                  href="/reporting"
                  current={pathname.startsWith("/reporting")}
                >
                  <BarChartBigIcon className="h-5 w-5" />
                  <SidebarLabel>Rapports</SidebarLabel>
                </SidebarItem>
              )}
            </SidebarSection>

            <SidebarSpacer />

            <SidebarSection>
              <ThemeToggler className="flex flex-row justify-start w-full text-base/6 font-medium text-zinc-950 sm:py-2 sm:text-sm/5">
                Thème
              </ThemeToggler>
            </SidebarSection>
          </SidebarBody>

          <SidebarFooter className="max-lg:hidden">
            <UserButton
              showName
              appearance={{ elements: { userButtonBox: "flex-row-reverse!" } }}
            />
          </SidebarFooter>
        </Sidebar>
      }
    >
      {children}
    </SidebarLayout>
  );
}
