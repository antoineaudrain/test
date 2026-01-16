import EmailEmpty from "@/assets/illustrations/email-empty.svg";
import { ContactForm } from "@/features/marketing/components/ContactForm";
import { Container } from "@/features/marketing/components/Container";
import { EmptyState } from "@/features/shared/components";

type ContactProps = {
  formDisabled?: boolean;
};

export function Contact({ formDisabled }: ContactProps) {
  return (
    <section id="contact" className="pt-20 pb-14 sm:pt-32 sm:pb-20 lg:pb-32">
      <Container>
        <div className="mx-auto max-w-2xl md:text-center">
          <h2 className="font-display text-3xl tracking-tight text-slate-900 sm:text-4xl">
            Discutons de votre transport dentaire
          </h2>
          <p className="mt-4 text-lg tracking-tight text-slate-700">
            Un besoin urgent ? Une question sur nos tournées ? Ou juste curieux
            de voir si TDS peut vous simplifier la vie ? Remplissez le
            formulaire, on vous répond vite et bien.
          </p>
        </div>

        {formDisabled ? (
          <EmptyState
            icon={EmailEmpty}
            title="Merci pour votre intérêt !"
            description="Vous avez déjà soumis le formulaire aujourd'hui. Nous reviendrons vers vous dès que possible."
          />
        ) : (
          <ContactForm />
        )}
      </Container>
    </section>
  );
}
