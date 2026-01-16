import { redirect } from "next/navigation";
import type { Context } from "@/lib/permissions";
import { getContext, Policies, PolicyError } from "@/lib/permissions";

export async function requireAuth() {
  try {
    const ctx = await getContext();
    const policies = new Policies(ctx);
    return { ctx, policies };
  } catch (_error) {
    redirect("/sign-in");
  }
}

export async function requirePermission(
  check: (policies: Policies, ctx: Context) => void | Promise<void>,
  fallback: string = "/deliveries",
) {
  try {
    const { ctx, policies } = await requireAuth();

    await check(policies, ctx);

    return { ctx, policies };
  } catch (error) {
    if (error instanceof PolicyError) {
      const errorParam = encodeURIComponent(error.message);
      redirect(`${fallback}?error=${errorParam}`);
    }
    throw error;
  }
}

export async function checkPermission(
  check: (policies: Policies, ctx: Context) => void | Promise<void>,
): Promise<{
  hasPermission: boolean;
  ctx?: Context;
  policies?: Policies;
  error?: string;
}> {
  try {
    const ctx = await getContext();
    const policies = new Policies(ctx);
    await check(policies, ctx);
    return { hasPermission: true, ctx, policies };
  } catch (error) {
    if (error instanceof PolicyError) {
      return { hasPermission: false, error: error.message };
    }
    return { hasPermission: false, error: "Authentication required" };
  }
}

export async function requirePermissions(
  checks: Array<(policies: Policies, ctx: Context) => void | Promise<void>>,
  fallback: string = "/deliveries",
) {
  try {
    const { ctx, policies } = await requireAuth();

    for (const check of checks) {
      await check(policies, ctx);
    }

    return { ctx, policies };
  } catch (error) {
    if (error instanceof PolicyError) {
      const errorParam = encodeURIComponent(error.message);
      redirect(`${fallback}?error=${errorParam}`);
    }
    throw error;
  }
}
