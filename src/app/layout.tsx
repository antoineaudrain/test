import { frFR } from "@clerk/localizations";
import { ClerkProvider } from "@clerk/nextjs";
import type { Metadata } from "next";
import { Instrument_Sans } from "next/font/google";
import type { PropsWithChildren } from "react";
import ClientLayout from "@/app/ClientLayout";
import "@/assets/styles/global.css";

const instrumentSans = Instrument_Sans({
  subsets: ["latin"],
});

export const metadata: Metadata = {
  title: {
    template: "%s - Trans Dental Services",
    default: "Trans Dental Services",
  },
  metadataBase: new URL("https://www.tds-transports.fr"),
  description: "",
};

export default async function RootLayout({ children }: PropsWithChildren) {
  return (
    <html
      lang="fr"
      suppressHydrationWarning
      className={instrumentSans.className}
    >
      <head>
        <link rel="preconnect" href="https://rsms.me/" />
        <link rel="stylesheet" href="https://rsms.me/inter/inter.css" />
      </head>
      <body>
        <ClerkProvider
          localization={frFR}
          appearance={{ cssLayerName: "clerk" }}
        >
          <ClientLayout>{children}</ClientLayout>
        </ClerkProvider>
      </body>
    </html>
  );
}
