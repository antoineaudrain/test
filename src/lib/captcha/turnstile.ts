import { randomUUID } from "node:crypto";

export async function verifyTurnstile(
  token: string,
  ip: string,
): Promise<boolean> {
  try {
    const response = await fetch(
      "https://challenges.cloudflare.com/turnstile/v0/siteverify",
      {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: new URLSearchParams({
          secret: process.env.TURNSTILE_SECRET_KEY!,
          response: token,
          remoteip: ip,
          idempotency_key: randomUUID(),
        }),
      },
    );

    const result = await response.json();
    return result.success === true;
  } catch (error) {
    console.error("Turnstile verification failed:", error);
    return false;
  }
}
