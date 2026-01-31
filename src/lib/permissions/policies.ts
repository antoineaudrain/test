import type { Client } from "@/features/clients/types";
import type {
  Delivery,
  DeliveryWithRelations,
} from "@/features/deliveries/types";
import type { Employee } from "@/features/employees/types";
import {
  isPast,
  isTodayOrWithinStartWindow,
} from "@/features/shared/helper/time";
import type { Stop } from "@/features/stops/types";
import type { Vehicle } from "@/features/vehicles/types";
import { DeliveryStatus, type Prisma, StopStatus } from "@/generated/prisma";
import type { Context } from "@/lib/permissions";

export class PolicyError extends Error {
  constructor(message: string) {
    super(message);
    this.name = "PolicyError";
  }
}

export class Policies {
  constructor(private ctx: Context) {}

  isCurrentCompanyId(companyId: string): boolean {
    return this.ctx.company.id === companyId;
  }

  canCheckPermission(check: () => void): boolean {
    try {
      check();
      return true;
    } catch {
      return false;
    }
  }

  // ============================================================================
  // COMPANY TYPE CHECKS
  // ============================================================================

  isDeliveryCompany(): boolean {
    return this.ctx.company.type === "DELIVERY";
  }

  isClientCompany(): boolean {
    return this.ctx.company.type === "CLIENT";
  }

  isEndClientCompany(): boolean {
    return this.ctx.company.type === "END_CLIENT";
  }

  // ============================================================================
  // ROLE-BASED CHECKS
  // ============================================================================

  isAdmin(): boolean {
    return this.ctx.user.role === "ADMIN";
  }

  isManager(): boolean {
    return this.ctx.user.role === "MANAGER";
  }

  isMember(): boolean {
    return this.ctx.user.role === "MEMBER";
  }

  isDriver(): boolean {
    return this.isDeliveryCompany() && Boolean(this.ctx.vehicle);
  }

  // ============================================================================
  // EMPLOYEE POLICIES
  // ============================================================================

  canViewEmployeeListPage(): void {
    if (this.isEndClientCompany())
      throw new PolicyError("Only deliveries companies can view employees");
  }

  canViewEmployeeDetailsPage(): void {
    if (this.isEndClientCompany())
      throw new PolicyError("Only deliveries companies can view employees");
  }

  canViewEmployee<T extends Employee>(employee: T): void {
    if (!this.isCurrentCompanyId(employee.companyId))
      throw new PolicyError("Can only view employees from the same company");
  }

  canViewEmployees<T extends Employee>(employees: T[]): void {
    employees.forEach((employee) => this.canViewEmployee(employee));
  }

  canUpdateEmployee<T extends Employee>(employee: T): void {
    if (this.isMember())
      throw new PolicyError("Only admins and managers can update employee");
    if (!this.isCurrentCompanyId(employee.companyId))
      throw new PolicyError("Can only update employees from the same company");
  }

  // ============================================================================
  // CLIENT POLICIES
  // ============================================================================

  canViewClientListPage(): void {
    if (this.isEndClientCompany())
      throw new PolicyError("Only deliveries companies can view employees");
  }

  canViewClientDetailsPage(): void {
    if (this.isEndClientCompany())
      throw new PolicyError("Only deliveries companies can view employees");
  }

  canViewClientNewPage(): void {
    if (this.isEndClientCompany())
      throw new PolicyError("End client companies cannot new companies");
    if (this.isMember())
      throw new PolicyError("Only admins and managers can new companies");
  }

  canViewClient<C extends Client>(client: C): void {
    if (!client?.parentId)
      throw new PolicyError("Can only view clients companies");
    if (!this.isDeliveryCompany() && !this.isCurrentCompanyId(client.parentId))
      throw new PolicyError("Can only view clients from the same company");
  }

  canViewClients<C extends Client>(clients: C[]): void {
    clients.forEach((client) => this.canViewClient(client));
  }

  canCreateCompany(): void {
    if (this.isEndClientCompany())
      throw new PolicyError("End client companies cannot new companies");
    if (this.isMember())
      throw new PolicyError("Only admins and managers can new companies");
  }

  canCreateClientCompany(): void {
    if (!this.isDeliveryCompany())
      throw new PolicyError("Only delivery companies can new client companies");
    if (this.isMember())
      throw new PolicyError("Only admins and managers can new companies");
  }

  canCreateEndClientCompany(): void {
    if (!this.isClientCompany())
      throw new PolicyError(
        "Only client companies can new end client companies",
      );
    if (this.isMember())
      throw new PolicyError("Only admins and managers can new companies");
  }

  canUpdateClient<T extends Prisma.CompanyGetPayload<{}>>(client: T): void {
    if (this.isMember())
      throw new PolicyError("Only admins and managers can update client");
    if (
      !this.isEndClientCompany() &&
      client.parentId &&
      !this.isCurrentCompanyId(client.parentId)
    )
      throw new PolicyError(
        "Can only update role of clients from the same company",
      );
  }

  // ============================================================================
  // VEHICLE POLICIES
  // ============================================================================

  canViewVehicleListPage(): void {
    if (!this.isDeliveryCompany())
      throw new PolicyError("Only deliveries companies can view vehicles");
  }

  canViewVehicle<T extends Vehicle>(vehicle: T): void {
    if (!this.isDeliveryCompany())
      throw new PolicyError("Only deliveries companies can view vehicles");
    if (!this.isCurrentCompanyId(vehicle.companyId))
      throw new PolicyError("Can only view vehicles from the same company");
  }

  canViewVehicles<T extends Vehicle>(vehicles: T[]): void {
    if (!this.isDeliveryCompany())
      throw new PolicyError("Only deliveries companies can view vehicles");
    vehicles.forEach((vehicle) => this.canViewVehicle(vehicle));
  }

  // ============================================================================
  // DELIVERIES POLICIES
  // ============================================================================

  canViewDeliveryListPage(): void {
    if (this.isEndClientCompany())
      throw new PolicyError(
        "Only deliveries companies and client companies can view deliveries",
      );
  }

  canViewDeliveryDetailsPage(): void {
    if (this.isEndClientCompany())
      throw new PolicyError("Only deliveries companies can view employees");
  }

  canViewDeliveryCompletedPage<
    D extends DeliveryWithRelations<{ stops: true }>,
  >(delivery: D): void {
    if (!this.isDeliveryCompany())
      throw new PolicyError(
        "Only delviery company can view deliveries completed page",
      );
    if (delivery.deliveryStatus !== DeliveryStatus.IN_PROGRESS)
      throw new PolicyError("Can only view to be completed deliveries");
    if (
      delivery.stops.some(
        (stop) => !["DELIVERED", "FAILED"].includes(stop.status),
      )
    )
      throw new PolicyError(
        "Can only view deliveries with completed or failed stops",
      );
  }

  canViewDeliveryNewPage(): void {
    if (!this.isClientCompany())
      throw new PolicyError("Only client companies can new client");
  }

  canViewDelivery<
    D extends DeliveryWithRelations<{
      stops: { include: { endClientCompany: true } };
    }>,
  >(delivery: D): void {
    if (
      this.isDeliveryCompany() &&
      !this.isCurrentCompanyId(delivery.deliveryCompanyId)
    )
      throw new PolicyError("Can only view related deliveries");

    if (this.isClientCompany()) {
      // Check if any stop in the delivery goes to an end client that belongs to this client company
      const hasRelevantStops = delivery.stops.some(
        (stop) => stop.endClientCompany?.parentId === this.ctx.company.id,
      );
      if (!hasRelevantStops)
        throw new PolicyError("Can only view related deliveries");
    }
  }

  canViewDeliveries<
    D extends DeliveryWithRelations<{
      stops: { include: { endClientCompany: true } };
    }>,
  >(deliveries: D[]): void {
    deliveries.forEach((delivery) => this.canViewDelivery(delivery));
  }

  canDeleteDeliveries<D extends Delivery>(delivery: D): void {
    if (!this.isDeliveryCompany())
      throw new PolicyError("Only client can delete deliveries");
    if (!this.isCurrentCompanyId(delivery.deliveryCompanyId))
      throw new PolicyError("Can only delete related deliveries");
    if (delivery.deliveryStatus !== "SCHEDULED")
      throw new PolicyError("Can only delete scheduled deliveries");
  }

  canUpdateDeliveryStops<
    D extends DeliveryWithRelations<{
      stops: { include: { endClientCompany: true } };
    }>,
  >(delivery: D): void {
    if (!this.isClientCompany())
      throw new PolicyError("Only client can update delivery stops");

    // Check if any stop in the delivery goes to an end client that belongs to this client company
    const hasRelevantStops = delivery.stops.some(
      (stop) => stop.endClientCompany?.parentId === this.ctx.company.id,
    );
    if (!hasRelevantStops)
      throw new PolicyError(
        "Can only update delivery stops from the same company",
      );

    if (isPast(delivery.date))
      throw new PolicyError("Cannot update past delivery stops");
    if (delivery.deliveryStatus && delivery.deliveryStatus !== "SCHEDULED")
      throw new PolicyError("Can only update scheduled delivery stops");
  }

  canUpdateDeliverySequence<D extends Delivery>(delivery: D): void {
    if (!this.isDeliveryCompany())
      throw new PolicyError("Only delivery can update delivery sequence");
    if (!this.isCurrentCompanyId(delivery.deliveryCompanyId))
      throw new PolicyError(
        "Can only update delivery sequence from the same company",
      );
    if (delivery.deliveryStatus !== "SCHEDULED")
      throw new PolicyError("Can only update pending delivery");
  }

  canViewDeliveryStopTable<
    D extends DeliveryWithRelations<{
      stops: { include: { endClientCompany: true } };
    }>,
  >(delivery: D): void {
    if (this.isDeliveryCompany()) {
      if (!this.isCurrentCompanyId(delivery.deliveryCompanyId))
        throw new PolicyError(
          "Can only view delivery stops from the same company",
        );
      if (delivery.deliveryStatus === "SCHEDULED")
        throw new PolicyError("Can only view started deliveries");
      return;
    }

    if (this.isClientCompany()) {
      // Check if any stop in the delivery goes to an end client that belongs to this client company
      const hasRelevantStops = delivery.stops.some(
        (stop) => stop.endClientCompany?.parentId === this.ctx.company.id,
      );
      if (!hasRelevantStops)
        throw new PolicyError(
          "Can only view delivery stops from the same company",
        );
      return;
    }

    throw new PolicyError("Only client or delivery can view delivery stops");
  }

  canStartDelivery<D extends DeliveryWithRelations<{ stops: true }>>(
    delivery: D,
  ): void {
    if (!this.isDeliveryCompany())
      throw new PolicyError("Only deliveries companies can start delivery");
    // if (!isTodayOrWithinStartWindow(delivery.date))
    //   throw new PolicyError(
    //     "Can only start delivery on scheduled date or within 24 hours after",
    //   );
    if (delivery.driverId !== this.ctx.user.id)
      throw new PolicyError("Can only start assigned delivery");
    if (delivery.deliveryStatus !== "SCHEDULED")
      throw new PolicyError("Can only start scheduled delivery");
    if (!delivery.stops.every((stop) => stop.status === StopStatus.PLANNED))
      throw new PolicyError("Can only start delivery with uncompleted stops");
  }

  canResumeDelivery<D extends DeliveryWithRelations<{ stops: true }>>(
    delivery: D,
  ): void {
    if (!this.isDeliveryCompany())
      throw new PolicyError("Only deliveries companies can resume delivery");
    if (delivery.driverId !== this.ctx.user.id)
      throw new PolicyError("Can only resume assigned delivery");
    if (delivery.deliveryStatus !== "IN_PROGRESS")
      throw new PolicyError("Can only resume ongoing delivery");
    if (
      !delivery.stops.some((stop) =>
        ["PLANNED", "EN_ROUTE"].includes(stop.status),
      )
    )
      throw new PolicyError("Can only resume delivery with uncompleted stops");
  }

  canOpenWaybill<D extends DeliveryWithRelations<{ stops: true }>>(
    delivery: D,
  ): void {
    if (delivery.deliveryStatus !== "COMPLETED")
      throw new PolicyError("Can only open waybill for completed delivery");
  }

  // ============================================================================
  // STOPS POLICIES
  // ============================================================================

  canViewStop<S extends Stop>(stop: S): void {
    if (!this.isDeliveryCompany())
      throw new PolicyError("Only deliveries companies can view stop");
    if (stop.status === StopStatus.PLANNED)
      throw new PolicyError("Can only view started stops");
  }

  // ============================================================================
  // REPORTING POLICIES
  // ============================================================================

  canViewReportingPage(): void {
    if (!this.isClientCompany())
      throw new PolicyError("Only client companies can view reporting page");
  }

  canViewReportingDetailsPage(): void {
    if (!this.isClientCompany())
      throw new PolicyError("Only client companies can view reporting page");
  }

  // ============================================================================
  // DELIVERY REQUEST POLICIES
  // ============================================================================

  canViewDeliveryRequestListPage(): void {
    if (!this.isClientCompany())
      throw new PolicyError("Only client companies can view delivery requests");
  }

  canViewDeliveryRequestNewPage(): void {
    if (!this.isClientCompany())
      throw new PolicyError("Only client companies can new delivery requests");
  }

  canCreateDeliveryRequest(): void {
    if (!this.isClientCompany())
      throw new PolicyError("Only client companies can new delivery requests");
  }

  canUpdateDeliveryRequest(): void {
    if (!this.isClientCompany())
      throw new PolicyError(
        "Only client companies can update delivery requests",
      );
  }

  canCancelDeliveryRequest(): void {
    if (!this.isClientCompany())
      throw new PolicyError(
        "Only client companies can cancel delivery requests",
      );
  }

  canViewDeliveryRequest<
    T extends { clientCompanyId: string; deliveryCompanyId: string },
  >(request: T): void {
    // Client companies can view their own requests
    if (this.isClientCompany()) {
      if (!this.isCurrentCompanyId(request.clientCompanyId)) {
        throw new PolicyError(
          "Can only view delivery requests from the same company",
        );
      }
      return;
    }

    // Delivery companies can view requests assigned to them
    if (this.isDeliveryCompany()) {
      if (!this.isCurrentCompanyId(request.deliveryCompanyId)) {
        throw new PolicyError(
          "Can only view delivery requests assigned to your company",
        );
      }
      return;
    }

    throw new PolicyError(
      "Only client and delivery companies can view delivery requests",
    );
  }

  canModifyDeliveryRequest<T extends { clientCompanyId: string }>(
    request: T,
  ): void {
    // Only client companies can modify requests
    if (!this.isClientCompany())
      throw new PolicyError(
        "Only client companies can modify delivery requests",
      );
    if (!this.isCurrentCompanyId(request.clientCompanyId))
      throw new PolicyError(
        "Can only modify delivery requests from the same company",
      );
  }

  // ============================================================================
  // ADMIN DELIVERY MANAGEMENT POLICIES
  // ============================================================================

  canViewAdminDeliveriesPage(): void {
    if (!this.isDeliveryCompany())
      throw new PolicyError(
        "Only delivery companies can access admin deliveries",
      );
    if (this.isMember())
      throw new PolicyError(
        "Only admins and managers can access admin deliveries",
      );
  }

  canViewDeliveryCreationPage(): void {
    if (!this.isDeliveryCompany())
      throw new PolicyError("Only delivery companies can new deliveries");
    if (this.isMember())
      throw new PolicyError("Only admins and managers can new deliveries");
  }

  canSaveDeliveries(): void {
    if (!this.isDeliveryCompany())
      throw new PolicyError("Only delivery companies can save deliveries");
    if (this.isMember())
      throw new PolicyError("Only admins and managers can save deliveries");
  }

  // ============================================================================
  // CLIENT SETTINGS POLICIES
  // ============================================================================

  canUpdateClientSettings(): void {
    if (!this.isDeliveryCompany())
      throw new PolicyError(
        "Only delivery companies can update client settings",
      );
    if (!this.isAdmin())
      throw new PolicyError("Only admins can update client settings");
  }
}
