"use client";

import {
  HeartHandshakeIcon,
  type LucideIcon,
  ShieldCheckIcon,
  SproutIcon,
  TimerIcon,
} from "lucide-react";
import Image from "next/image";
import { useEffect, useState } from "react";
import backgroundImage from "@/assets/background-features.jpg";
import Photo from "@/assets/feature-vehicle.png";
import { Container } from "@/features/marketing/components/Container";

type PrimaryFeature = {
  title: string;
  description: string;
  icon: LucideIcon;
};

const primaryFeatures: Array<PrimaryFeature> = [
  {
    title: "Ponctualité",
    description:
      "Livraison précise et fiable pour dentistes et prothésistes : vos fournitures dentaires et prothèses arrivent toujours à l’heure, afin de respecter vos rendez-vous et votre planning.",
    icon: TimerIcon,
  },
  {
    title: "Sécurité",
    description:
      "Transport sécurisé et traçable de vos travaux dentaires sensibles. Chaque prothèse et matériel est manipulé avec soin, garantissant intégrité et fiabilité à chaque livraison.",
    icon: ShieldCheckIcon,
  },
  {
    title: "Écologie",
    description:
      "Flotte 100% électrique, zéro émission et livraison silencieuse. Offrez à votre cabinet un service de livraison moderne, responsable et durable, sans compromettre la rapidité ou la qualité.",
    icon: SproutIcon,
  },
  {
    title: "Disponibilité",
    description:
      "Livraisons flexibles et assistance réactive : nous nous adaptons à vos horaires et imprévus pour garantir un service sans faille.",
    icon: HeartHandshakeIcon,
  },
];

export function PrimaryFeatures() {
  const [_tabOrientation, setTabOrientation] = useState<
    "horizontal" | "vertical"
  >("horizontal");

  useEffect(() => {
    const lgMediaQuery = window.matchMedia("(min-width: 1024px)");

    function onMediaQueryChange({ matches }: { matches: boolean }) {
      setTabOrientation(matches ? "vertical" : "horizontal");
    }

    onMediaQueryChange(lgMediaQuery);
    lgMediaQuery.addEventListener("change", onMediaQueryChange);

    return () => {
      lgMediaQuery.removeEventListener("change", onMediaQueryChange);
    };
  }, []);

  return (
    <section
      id="primaryFeatures"
      className="relative overflow-hidden bg-blue-600 pt-20 pb-28 sm:py-32"
    >
      <Image
        className="absolute top-1/2 left-1/2 max-w-none translate-x-[-44%] translate-y-[-42%]"
        src={backgroundImage}
        alt=""
        width={2245}
        height={1636}
        unoptimized
      />
      <Container className="relative">
        <div className="max-w-2xl md:mx-auto md:text-center xl:max-w-none">
          <h2 className="font-display text-3xl tracking-tight text-white sm:text-4xl md:text-5xl">
            Choisi par les professionnels dentaires
          </h2>
          <p className="mt-6 text-lg tracking-tight text-blue-100">
            Simplifiez vos livraisons pour vous concentrer sur vos patients, pas
            sur la logistique.
          </p>
        </div>
        <div className="mt-16 grid grid-cols-1 items-center gap-y-2 pt-10 sm:gap-y-6 md:mt-20 lg:grid-cols-12 lg:pt-0">
          <div className="-mx-4 flex overflow-x-auto pb-4 sm:mx-0 sm:overflow-visible sm:pb-0 lg:col-span-5">
            <div className="relative z-10 flex gap-x-4 px-4 whitespace-nowrap sm:mx-auto sm:px-0 lg:mx-0 lg:block lg:gap-x-0 lg:gap-y-1 lg:whitespace-normal">
              {primaryFeatures.map((feature, _featureIndex) => (
                <div
                  key={feature.title}
                  className="relative rounded-full px-4 py-1 lg:rounded-l-xl lg:rounded-r-none lg:p-6"
                >
                  <feature.icon className="text-white" />
                  <h3>
                    <div className="mt-2 font-display text-lg data-selected:not-data-focus:outline-hidden text-white">
                      <span className="absolute inset-0 rounded-full lg:rounded-l-xl lg:rounded-r-none" />
                      {feature.title}
                    </div>
                  </h3>
                  <p className="mt-2 hidden text-sm lg:block text-blue-100">
                    {feature.description}
                  </p>
                </div>
              ))}
            </div>
          </div>
          <div className="lg:col-span-7">
            <div className="mt-10 w-180 sm:w-auto lg:mt-0 lg:w-271.25">
              <Image
                className="w-full"
                src={Photo}
                alt=""
                priority
                sizes="(min-width: 1024px) 67.8125rem, (min-width: 640px) 100vw, 45rem"
              />
            </div>
          </div>
        </div>
      </Container>
    </section>
  );
}
