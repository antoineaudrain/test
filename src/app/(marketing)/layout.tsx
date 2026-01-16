import { auth } from "@clerk/nextjs/server";
import type { Metadata } from "next";
import { redirect } from "next/navigation";
import type { PropsWithChildren } from "react";

export const metadata: Metadata = {
  title:
    "Trans Dental Services | Transport spécialisé pour prothèses dentaires",
  description:
    "Transport spécialisé de prothèses dentaires dans les Alpes françaises. Livraison rapide, sécurisée et 100% électrique pour laboratoires, cabinets et spécialistes dentaires.",
  keywords: [
    "transport dentaire",
    "livraison prothèses dentaires",
    "transport empreintes dentaires",
    "transport gouttières dentaires",
    "Alpes françaises",
    "laboratoire dentaire",
    "cabinet dentaire",
  ],
  openGraph: {
    title: "Trans Dental Services",
    description:
      "Vos prothèses et empreintes dentaires livrées sans stress dans les Alpes françaises. Transport fiable, rapide et écologique.",
    url: "https://www.tds-transports.fr/",
    siteName: "Trans Dental Services",
    images: [
      {
        url: "/og-image.jpg",
        width: 1200,
        height: 630,
        alt: "Transport dentaire Alpes françaises",
      },
    ],
    locale: "fr_FR",
    type: "website",
  },
  twitter: {
    card: "summary_large_image",
    title: "Trans Dental Services",
    description:
      "Spécialistes du transport dentaire dans les Alpes françaises. Livraison fiable et écologique.",
    images: ["/og-image.jpg"],
  },
  alternates: {
    canonical: "https://www.tds-transports.fr/",
  },
};

export default async function RootLayout({ children }: PropsWithChildren) {
  const { userId } = await auth();
  if (userId) {
    redirect("/deliveries");
  }

  return children;
}
