"use server";

import type { Context } from "@/lib/permissions";
import { getContext, Policies } from "@/lib/permissions";

export async function withAuth<T>(
  action: (ctx: Context, policies: Policies) => Promise<T>,
): Promise<T> {
  try {
    const ctx = await getContext();
    const policies = new Policies(ctx);
    return action(ctx, policies);
  } catch (error) {
    console.error("withAuth error:", error);
    throw error;
  }
}
