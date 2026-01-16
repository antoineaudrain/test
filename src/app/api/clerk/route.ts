import { verifyWebhook } from "@clerk/nextjs/webhooks";
import type { NextRequest } from "next/server";
import { updateUser } from "@/features/users/actions/mutations/updateUser";

export async function POST(req: NextRequest) {
  try {
    const event = await verifyWebhook(req);
    const type = event.type;

    if (type === "user.updated") {
      await updateUser(event.data);
      return new Response("User updated successfully", { status: 200 });
    }

    console.warn("Unhandled event type ");
    return new Response("Unhandled event type", { status: 200 });
  } catch (err) {
    console.error("Error verifying webhook:", err);
    return new Response("Error verifying webhook", { status: 400 });
  }
}
