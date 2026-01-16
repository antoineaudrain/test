"use client";

import { zodResolver } from "@hookform/resolvers/zod";
import { Turnstile, type TurnstileInstance } from "@marsidev/react-turnstile";
import { useCallback, useRef } from "react";
import { useForm } from "react-hook-form";
import { Button } from "@/features/marketing/components/Button";
import {
  type SendContactEmailFormInput,
  SendContactEmailFormSchema,
} from "@/features/marketing/schemas/sendContactEmail";
import {
  ErrorMessage,
  Field,
  FieldGroup,
  Input,
  Label,
  Textarea,
} from "@/features/shared/components";
import { sendContactEmail } from "../actions/mutations/sendContactEmail";

export function ContactForm() {
  const turnstileRef = useRef<TurnstileInstance>(null);

  const {
    register,
    handleSubmit,
    formState: { errors, isSubmitting },
    setError,
    clearErrors,
    reset,
  } = useForm({
    resolver: zodResolver(SendContactEmailFormSchema),
  });

  const onSubmit = useCallback(
    async (input: SendContactEmailFormInput) => {
      clearErrors();

      const token = turnstileRef.current?.getResponse();
      if (!token) {
        return setError("root", {
          message: "Vérification de sécurité échouée. Veuillez réessayer.",
        });
      }

      try {
        await sendContactEmail({ input, token });
        reset();
      } catch (error) {
        // @ts-expect-error
        setError("root", { message: error.message });
      } finally {
        turnstileRef.current?.reset();
      }
    },
    [clearErrors, setError, reset],
  );

  const handleTurnstileError = useCallback(() => {
    setError("root", {
      message:
        "Erreur de vérification de sécurité. Veuillez recharger la page.",
    });
  }, [setError]);

  return (
    <form
      onSubmit={handleSubmit(onSubmit)}
      className="mx-auto mt-16 max-w-xl sm:mt-20"
    >
      <FieldGroup>
        <div className="grid grid-cols-1 gap-8 sm:grid-cols-2 sm:gap-4">
          <Field>
            <Label>Email</Label>
            <Input
              {...register("email")}
              type="email"
              placeholder="contact@acme.fr"
              invalid={!!errors?.email}
            />
            {errors?.email && (
              <ErrorMessage>{errors.email.message}</ErrorMessage>
            )}
          </Field>

          <Field>
            <Label>Nom de votre entreprise</Label>
            <Input
              {...register("companyName")}
              type="text"
              placeholder="Acme"
              invalid={!!errors?.companyName}
            />
            {errors?.companyName && (
              <ErrorMessage>{errors.companyName.message}</ErrorMessage>
            )}
          </Field>
        </div>

        <Field>
          <Label>Message</Label>
          <Textarea
            {...register("message")}
            rows={5}
            placeholder="Expliquez-nous rapidement votre besoin, vos horaires ou vos questions..."
            invalid={!!errors?.message}
          />
          {errors?.message && (
            <ErrorMessage>{errors.message.message}</ErrorMessage>
          )}
        </Field>

        <Field>
          {errors.root?.message && (
            <ErrorMessage>{errors.root?.message}</ErrorMessage>
          )}
        </Field>
      </FieldGroup>

      <Turnstile
        ref={turnstileRef}
        siteKey={process.env.NEXT_PUBLIC_TURNSTILE_SITE_KEY!}
        options={{ theme: "light", size: "invisible" }}
        onError={handleTurnstileError}
      />

      <div className="mt-10 text-center">
        <Button disabled={isSubmitting} color="blue" type="submit">
          {isSubmitting ? (
            <span className="flex items-center justify-center gap-2">
              <div className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin" />
              Envoi en cours...
            </span>
          ) : (
            "Envoyer ma demande"
          )}
        </Button>
      </div>
    </form>
  );
}
