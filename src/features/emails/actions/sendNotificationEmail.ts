import { render } from "@react-email/render";
import type { JSX } from "react";
import { EmailSendError } from "@/features/emails/errors/error";
import { ResendClient } from "@/lib/email/resend";

type Tag = {
  name: string;
  value: string;
};

type EmailMeta = {
  source: string;
  type: string;
  priority: string;
} & { [key: string]: string | undefined };

type SendNotificationEmailArgs = {
  subject: string;
  template: JSX.Element;
  meta: EmailMeta;
  email?: string;
};

export async function sendNotificationEmail({
  email = "contact@tds-transports.fr",
  template,
  subject,
  meta,
}: SendNotificationEmailArgs) {
  try {
    const html = await render(template);
    const tags = Object.entries(meta).reduce<Tag[]>((acc, [name, value]) => {
      if (value) {
        acc.push({ name, value });
      }
      return acc;
    }, []);

    const { error } = await ResendClient.emails.send({
      from: "notifications@tds-transports.fr",
      to: email,
      subject,
      html,
      tags: [
        ...tags,
        { name: "environment", value: process.env.NODE_ENV || "development" },
      ],
    });

    if (error) {
      console.error("Resend API error:", { subject, meta, error });
      throw new EmailSendError("Could not send email", error);
    }
  } catch (err) {
    if (err instanceof EmailSendError) throw err;

    console.error("Unexpected email error:", { subject, meta, err });
    throw new EmailSendError("Email send failed", err);
  }
}
