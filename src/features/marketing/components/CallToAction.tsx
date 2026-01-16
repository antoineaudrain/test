import Image from "next/image";
import backgroundImage from "@/assets/background-call-to-action.jpg";
import { Button } from "@/features/marketing/components/Button";
import { Container } from "@/features/marketing/components/Container";

export function CallToAction() {
  return (
    <section
      id="get-started-today"
      className="relative overflow-hidden bg-blue-600 py-32"
    >
      <Image
        className="absolute top-1/2 left-1/2 max-w-none -translate-x-1/2 -translate-y-1/2"
        src={backgroundImage}
        alt=""
        width={2347}
        height={1244}
        unoptimized
      />
      <Container className="relative">
        <div className="mx-auto max-w-lg text-center">
          <h2 className="font-display text-3xl tracking-tight text-white sm:text-4xl">
            Un transport qui suit votre rythme
          </h2>
          <p className="mt-4 text-lg tracking-tight text-white">
            Prothèses, empreintes, gouttières, on s’occupe de tout, exactement
            quand il faut. Et c’est plus simple que vous le pensez.
          </p>
          <Button href="#contact" color="white" className="mt-10">
            Demander mes tarifs
          </Button>
        </div>
      </Container>
    </section>
  );
}
