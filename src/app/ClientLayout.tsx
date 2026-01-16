"use client";

import { ProgressProvider } from "@bprogress/next/app";
import type { PropsWithChildren } from "react";

export default function ClientLayout({ children }: PropsWithChildren) {
  return (
    <ProgressProvider height="1px" color="#2B7FFF" shallowRouting>
      {children}
    </ProgressProvider>
  );
}
