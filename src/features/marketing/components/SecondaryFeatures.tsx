"use client";

import {
  BriefcaseMedicalIcon,
  FlaskConicalIcon,
  HospitalIcon,
  type LucideIcon,
} from "lucide-react";
import Image from "next/image";
import Photo from "@/assets/feature-segment.png";
import { Container } from "@/features/marketing/components/Container";

type SecondaryFeature = {
  summary: string;
  name: string;
  description: string;
  icon: LucideIcon;
};

const secondaryFeatures: Array<SecondaryFeature> = [
  {
    summary: "Laboratoires Dentaires",
    name: "Livraisons précises, zéro stress",
    description:
      "Vos prothèses, empreintes et gouttières sont récupérées et livrées exactement quand il le faut. Fini les retards et les contraintes logistiques.",
    icon: FlaskConicalIcon,
  },
  {
    summary: "Cabinets & Cliniques",
    name: "Transport fiable et discret",
    description:
      "Recevez vos matériels dentaires rapidement, en toute sécurité et confidentialité. Vous gagnez du temps et gardez vos patients au centre.",
    icon: HospitalIcon,
  },
  {
    summary: "Spécialistes Dentaires\n",
    name: "Flexible selon votre planning",
    description:
      "Nous nous adaptons à votre planning pour livrer vos prothèses et empreintes quand vous en avez besoin. Plus de stress, plus de concentration sur vos patients.",
    icon: BriefcaseMedicalIcon,
  },
];

function Feature({
  feature,
  isActive,
  className,
  ...props
}: React.ComponentPropsWithoutRef<"div"> & {
  feature: SecondaryFeature;
  isActive: boolean;
}) {
  return (
    <div className={className} {...props}>
      <div className="w-9 h-9 flex items-center justify-center rounded-lg bg-blue-600">
        <feature.icon className="size-6 text-white" />
      </div>
      <h3 className="mt-6 text-sm font-medium text-blue-600">{feature.name}</h3>
      <p className="mt-2 font-display text-xl text-slate-900">
        {feature.summary}
      </p>
      <p className="mt-4 text-sm text-slate-600">{feature.description}</p>
    </div>
  );
}

function FeaturesMobile() {
  return (
    <div className="-mx-4 mt-20 flex flex-col gap-y-10 overflow-hidden px-4 sm:-mx-6 sm:px-6 lg:hidden">
      {secondaryFeatures.map((feature) => (
        <div key={feature.summary}>
          <Feature feature={feature} className="mx-auto max-w-2xl" isActive />
        </div>
      ))}

      <div className="relative mt-10 mx-auto">
        <Image
          className="w-full h-75 object-cover -ml-4"
          src={Photo}
          alt="Livreuse portant un colis et un presse-papiers dans la rue, avec masque et gants."
          sizes="52.75rem"
        />
      </div>
    </div>
  );
}

function FeaturesDesktop() {
  return (
    <div className="hidden lg:mt-20 lg:block">
      <div className="grid grid-cols-3 gap-x-8">
        {secondaryFeatures.map((feature) => (
          <Feature
            isActive={false}
            key={feature.summary}
            feature={feature}
            className="relative"
          />
        ))}
      </div>

      <div className="relative mt-20">
        <Image
          className="w-full h-100 object-contain"
          src={Photo}
          alt="Livreuse portant un colis et un presse-papiers dans la rue, avec masque et gants."
          sizes="52.75rem"
        />
      </div>
    </div>
  );
}

export function SecondaryFeatures() {
  return (
    <section id="about-us" className="pt-20 sm:pt-32">
      <Container>
        <div className="mx-auto max-w-2xl md:text-center">
          <h2 className="font-display text-3xl tracking-tight text-slate-900 sm:text-4xl">
            Adapté à chaque professionnel dentaire
          </h2>
          <p className="mt-4 text-lg tracking-tight text-slate-700">
            Que vous soyez laboratoire, cabinet ou spécialiste, nous adaptons
            nos collectes et livraisons pour gagner du temps.
          </p>
        </div>
        <FeaturesMobile />
        <FeaturesDesktop />
      </Container>
    </section>
  );
}
