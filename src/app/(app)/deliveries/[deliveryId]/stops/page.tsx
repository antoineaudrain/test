import { redirect } from "next/navigation";
import { resumeDelivery } from "@/features/deliveries/actions/mutations/resumeDelivery";

type DeliveryStepsPageProps = {
  params: Promise<{ deliveryId: string }>;
};

export default async function DeliveryStepsPage({
  params,
}: DeliveryStepsPageProps) {
  const { deliveryId } = await params;
  try {
    await resumeDelivery({ deliveryId });
  } catch {
    redirect(`/deliveries/${deliveryId}`);
  }
}
