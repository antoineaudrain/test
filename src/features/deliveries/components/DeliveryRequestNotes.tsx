"use client";

import type { GetDeliveryReturn } from "@/features/deliveries/actions/queries/getDelivery";
import { Text } from "@/features/shared/components";

type DeliveryRequestNotesProps = {
  delivery: NonNullable<GetDeliveryReturn>;
  currentUserCompanyId: string;
  isClientCompany: boolean;
};

export function DeliveryRequestNotes({
  delivery,
  currentUserCompanyId,
  isClientCompany,
}: DeliveryRequestNotesProps) {
  // Extract unique delivery requests with notes
  const requestNotesMap = new Map<
    string,
    {
      requestId: string;
      clientName: string;
      notes: string;
      clientCompanyId: string;
    }
  >();

  for (const stop of delivery.stops) {
    if (stop.sourceRequestStop?.request) {
      const request = stop.sourceRequestStop.request;
      if (request.notes && !requestNotesMap.has(request.id)) {
        requestNotesMap.set(request.id, {
          requestId: request.id,
          clientName: request.clientCompany.name,
          notes: request.notes,
          clientCompanyId: request.clientCompanyId,
        });
      }
    }
  }

  // Filter notes based on user's company type
  const visibleNotes = Array.from(requestNotesMap.values()).filter((note) => {
    if (isClientCompany) {
      // Client companies only see their own notes
      return note.clientCompanyId === currentUserCompanyId;
    }
    // Delivery companies see all notes
    return true;
  });

  if (visibleNotes.length === 0) {
    return <Text className="italic opacity-30">Pas de notes</Text>;
  }

  if (visibleNotes.length === 1) {
    // Single note: display without bullet point or client name if it's the client's own note
    const note = visibleNotes[0];
    if (isClientCompany) {
      return <Text>{note.notes}</Text>;
    }
    return (
      <Text>
        - {note.clientName}: {note.notes}
      </Text>
    );
  }

  // Multiple notes: display with bullet points and client names
  return (
    <div className="space-y-1">
      {visibleNotes.map((note) => (
        <Text key={note.requestId}>
          - {note.clientName}: {note.notes}
        </Text>
      ))}
    </div>
  );
}
