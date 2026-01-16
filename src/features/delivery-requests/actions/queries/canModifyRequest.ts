"use server";

import prisma from "@/lib/database/prisma";
import { withAuth } from "@/lib/permissions";
import { dateStringToDate, Time } from "@/lib/time";

type CanModifyRequestProps = {
  clientCompanyId: string;
  requestDate: string; // "YYYY-MM-DD"
};

export type CanModifyRequestResult = {
  canModify: boolean;
  timeRemaining?: number; // seconds until cutoff
  cutoffTime?: string; // "HH:mm"
};

export async function canModifyRequest({
  clientCompanyId,
  requestDate,
}: CanModifyRequestProps): Promise<CanModifyRequestResult> {
  return withAuth<CanModifyRequestResult>(async (_ctx, _policies) => {
    // Get client settings
    const settings = await prisma.clientSettings.findUnique({
      where: { clientCompanyId },
    });

    // No cutoff time configured - can always modify
    if (!settings?.cutoffTime) {
      return { canModify: true };
    }

    // Parse cutoff time
    const [hours, minutes] = settings.cutoffTime.split(":").map(Number);

    // Create cutoff datetime in Paris timezone
    const requestDateObj = dateStringToDate(requestDate);
    const cutoffDateTime = Time(requestDateObj)
      .hour(hours)
      .minute(minutes)
      .second(0);

    // Get current time in Paris timezone
    const now = Time();

    // Check if we're before cutoff
    const canModify = now.isBefore(cutoffDateTime);

    // Calculate time remaining in seconds
    const timeRemaining = cutoffDateTime.diff(now, "second");

    return {
      canModify,
      timeRemaining: timeRemaining > 0 ? timeRemaining : 0,
      cutoffTime: settings.cutoffTime,
    };
  });
}
