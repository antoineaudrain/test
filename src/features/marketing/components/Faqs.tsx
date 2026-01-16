import Image from "next/image";
import backgroundImage from "@/assets/background-faqs.jpg";
import { Container } from "@/features/marketing/components/Container";

const faqs = [
  [
    {
      question: "Est-ce que vous livrez uniquement pour le secteur dentaire ?",
      answer:
        "Oui, exclusivement. C’est notre spécialité — on comprend vos délais, vos exigences, vos impératifs cliniques.",
    },
    {
      question: "Que se passe-t-il en cas d’urgence ?",
      answer:
        "On intervient en express dans toute notre zone. Une demande, une solution. Sans stress.",
    },
  ],
  [
    {
      question:
        "Quelle est votre vraie différence par rapport à un transporteur classique ?",
      answer:
        "On ne fait que du dentaire. Pas de colis standards, pas de dispatch externe. Vos envois sont traités avec le même soin qu’un acte médical.",
    },
  ],
  [
    {
      question: "Livrez-vous dans ma zone ?",
      answer:
        "On couvre les Alpes françaises et zones limitrophes. Contactez-nous pour vérifier en 30 secondes.",
    },
    {
      question: "Utilisez-vous des véhicules écologiques ?",
      answer:
        "Oui, toute notre flotte est 100% électrique. Zéro émission, zéro bruit.",
    },
  ],
];

export function Faqs() {
  return (
    <section
      id="faq"
      className="relative overflow-hidden bg-slate-50 py-20 sm:py-32"
    >
      <Image
        className="absolute top-0 left-1/2 max-w-none translate-x-[-30%] -translate-y-1/4"
        src={backgroundImage}
        alt=""
        width={1558}
        height={946}
        unoptimized
      />
      <Container className="relative">
        <div className="mx-auto max-w-2xl lg:mx-0">
          <h2
            id="faq-title"
            className="font-display text-3xl tracking-tight text-slate-900 sm:text-4xl"
          >
            Vos questions, nos réponses
          </h2>
          <p className="mt-4 text-lg tracking-tight text-slate-700">
            Tout ce que vous devez savoir pour simplifier vos livraisons de
            prothèses dentaires.
          </p>
        </div>
        <ul className="mx-auto mt-16 grid max-w-2xl grid-cols-1 gap-8 lg:max-w-none lg:grid-cols-3">
          {faqs.map((column, columnIndex) => (
            <li key={columnIndex}>
              <ul className="flex flex-col gap-y-8">
                {column.map((faq, faqIndex) => (
                  <li key={faqIndex}>
                    <h3 className="font-display text-lg/7 text-slate-900">
                      {faq.question}
                    </h3>
                    <p className="mt-4 text-sm text-slate-700">{faq.answer}</p>
                  </li>
                ))}
              </ul>
            </li>
          ))}
        </ul>
      </Container>
    </section>
  );
}
