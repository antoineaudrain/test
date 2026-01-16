"use server";

import dynamic from "next/dynamic";
import { CallToAction } from "@/features/marketing/components/CallToAction";
import { Faqs } from "@/features/marketing/components/Faqs";
import { Footer } from "@/features/marketing/components/Footer";
import { Header } from "@/features/marketing/components/Header";
import { Hero } from "@/features/marketing/components/Hero";
import { SecondaryFeatures } from "@/features/marketing/components/SecondaryFeatures";
import { Testimonials } from "@/features/marketing/components/Testimonials";
import { contactFormRateLimiter } from "@/lib/rate-limiter/ContactFormRateLimiter";

const Contact = dynamic(() =>
  import("@/features/marketing/components/Contact").then((mod) => mod.Contact),
);

export default async function LandingPage() {
  const { allowed } = await contactFormRateLimiter.peek();

  return (
    <div className="flex h-full flex-col">
      <Header />
      <main>
        <Hero />
        <SecondaryFeatures />
        <CallToAction />
        <Testimonials />
        <Contact formDisabled={!allowed} />
        <Faqs />
      </main>
      <Footer />
    </div>
  );
}
