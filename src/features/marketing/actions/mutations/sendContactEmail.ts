"use server";

import { headers } from "next/headers";
import { sendNotificationEmail } from "@/features/emails/actions/sendNotificationEmail";
import { ContactConfirmation } from "@/features/emails/templates/ContactConfirmation";
import { ContactNotification } from "@/features/emails/templates/ContactNotification";
import {
  type SendContactEmailFormInput,
  SendContactEmailFormSchema,
} from "@/features/marketing/schemas/sendContactEmail";
import { verifyTurnstile } from "@/lib/captcha/turnstile";
import { contactFormRateLimiter } from "@/lib/rate-limiter/ContactFormRateLimiter";

type SendContactEmailProps = {
  input: SendContactEmailFormInput;
  token: string;
};

export async function sendContactEmail({
  input,
  token,
}: SendContactEmailProps): Promise<void> {
  const { allowed } = await contactFormRateLimiter.submit();
  if (!allowed) {
    throw new Error(
      "Vous avez déjà soumis le formulaire. Veuillez réessayer plus tard.",
    );
  }

  const { email, companyName, message } =
    SendContactEmailFormSchema.parse(input);

  const headersList = await headers();
  const visitorIpAddress =
    headersList.get("x-forwarded-for") ||
    headersList.get("cf-connecting-ip") ||
    "unknown-ip";

  const isValidCaptcha = await verifyTurnstile(token, visitorIpAddress);
  if (!isValidCaptcha) {
    throw new Error(
      "Vérification de sécurité échouée. Veuillez réessayer plus tard.",
    );
  }

  await sendNotificationEmail({
    email,
    subject: "Confirmation de réception - Nous avons bien reçu votre message",
    template: ContactConfirmation({ name: companyName }),
    meta: {
      source: "landing-page",
      type: "contact-confirmation",
      priority: "normal",
    },
  });

  await sendNotificationEmail({
    subject: `🔥 Nouveau Contact: ${companyName} - ${message.length > 10 ? `${message.slice(0, 10)}…` : message}`,
    template: ContactNotification({ name: companyName, email, message }),
    meta: {
      source: "landing-page",
      type: "contact-request",
      priority: "normal",
    },
  });
}
