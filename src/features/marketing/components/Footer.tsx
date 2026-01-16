import Logo from "@/assets/logo.svg";
import { Container } from "@/features/marketing/components/Container";
import { Time } from "@/lib/time";

export function Footer() {
  return (
    <footer className="bg-slate-50">
      <Container>
        <div className="py-16">
          <Logo className="mx-auto h-10 w-auto" />
        </div>
        <div className="flex flex-col items-center border-t border-slate-400/10 py-10 sm:flex-row-reverse sm:justify-between">
          <p className="mt-6 text-sm text-slate-500 sm:mt-0">
            Copyright &copy; {Time().year()} Trans Dental Services. Tous droits
            réservés.
          </p>
        </div>
      </Container>
    </footer>
  );
}
