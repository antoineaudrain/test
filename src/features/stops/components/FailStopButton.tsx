"use client";

import { zodResolver } from "@hookform/resolvers/zod";
import { CameraIcon, XIcon } from "lucide-react";
import type React from "react";
import { useRef, useState, useTransition } from "react";
import { useForm } from "react-hook-form";
import {
  Button,
  Dialog,
  DialogActions,
  DialogBody,
  DialogDescription,
  DialogTitle,
  ErrorMessage,
  Field,
  FieldGroup,
  Fieldset,
  Input,
  Label,
  Text,
  Textarea,
} from "@/features/shared/components";
import { failStop } from "@/features/stops/actions/mutations/failStop";
import {
  type FailStopInput,
  FailStopSchema,
} from "@/features/stops/schemas/failStop";

type FailStopButtonProps = {
  deliveryId: string;
  stopId: string;
};

export function FailStopButton({ deliveryId, stopId }: FailStopButtonProps) {
  const ref = useRef<HTMLInputElement>(null);
  const [isOpen, setIsOpen] = useState(false);
  const [isPending, startTransition] = useTransition();
  const [preview, setPreview] = useState<string | null>(null);

  const {
    register,
    handleSubmit,
    setValue,
    setError,
    formState: { errors },
    reset,
  } = useForm<FailStopInput>({ resolver: zodResolver(FailStopSchema) });

  const resetForm = () => {
    reset();
    setPreview(null);
    if (ref.current) ref.current.value = "";
  };

  const uploadFile = async (file: File) => {
    if (!file) return null;
    try {
      const buffer = Buffer.from(await file.arrayBuffer());
      const res = await fetch("/api/upload-image", {
        method: "POST",
        headers: { "X-File-Ext": "avif" },
        body: buffer,
      });
      const data = await res.json();
      return data?.url ?? null;
    } catch {
      setError("imageUrl", {
        type: "manual",
        message: "Échec de l'upload de l'image",
      });
      return null;
    }
  };

  const handleFail = handleSubmit(async (input) => {
    startTransition(async () => {
      const file = ref.current?.files?.[0];
      if (file) {
        const url = await uploadFile(file);
        if (!url) return;
        input.imageUrl = url;
      }

      await failStop({ deliveryId, stopId, input });
      setIsOpen(false);
      resetForm();
    });
  });

  const handleFile = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;

    if (file.size > 10 * 1024 * 1024) {
      return setError("imageUrl", {
        type: "manual",
        message: "La photo ne peut pas dépasser 10MB",
      });
    }

    if (!file.type.startsWith("image/")) {
      return setError("imageUrl", {
        type: "manual",
        message: "Veuillez sélectionner un fichier image valide",
      });
    }

    const reader = new FileReader();
    reader.onloadend = () => {
      setPreview(reader.result as string);
      setValue("imageUrl", reader.result as string);
    };
    reader.readAsDataURL(file);
  };

  return (
    <>
      <Button
        outline
        loading={isPending}
        onClick={() => setIsOpen(true)}
        className="rounded-r-none border-r-none flex-1"
      >
        <div className="py-1.5 flex flex-col items-center">
          <XIcon className="h-5 w-5 text-red-600" /> Annuler
        </div>
      </Button>

      <Dialog
        open={isOpen}
        onClose={() => {
          setIsOpen(false);
          resetForm();
        }}
      >
        <form onSubmit={handleFail}>
          <DialogTitle>Signaler un échec d'étape</DialogTitle>
          <DialogDescription>
            Cela marquera l'étape comme échouée et passera à l'étape suivante si
            disponible.
          </DialogDescription>

          <DialogBody>
            <Fieldset>
              <FieldGroup>
                <Field>
                  <div className="relative max-h-32 h-32 mt-8">
                    <button
                      type="button"
                      onClick={() => ref.current?.click()}
                      className="absolute inset-0 w-full h-full opacity-0 cursor-pointer z-10"
                    />
                    <div className="pointer-events-none border-2 border-dashed border-gray-300 rounded-lg p-6 text-center flex items-center justify-center w-full h-full overflow-hidden hover:border-gray-400 hover:bg-gray-50 transition-all">
                      {preview ? (
                        <img
                          src={preview}
                          alt="Preview"
                          className="w-full h-full object-contain"
                        />
                      ) : (
                        <div className="flex flex-col items-center gap-4 max-w-xs mx-auto">
                          <CameraIcon
                            strokeWidth={1.5}
                            className="h-12 w-12 text-zinc-500 dark:text-zinc-400"
                          />
                          <Text>Ajoutez une photo</Text>
                        </div>
                      )}
                    </div>
                  </div>
                  <Input
                    ref={ref}
                    type="file"
                    accept="image/*"
                    capture="environment"
                    onChange={handleFile}
                    className="hidden"
                  />
                  {errors.imageUrl && (
                    <ErrorMessage>{errors.imageUrl.message}</ErrorMessage>
                  )}
                </Field>
              </FieldGroup>

              <FieldGroup>
                <Field>
                  <Label>Raison</Label>
                  <Textarea
                    {...register("driverNotes")}
                    rows={3}
                    placeholder="Décrivez la raison de l'échec..."
                  />
                  {errors.driverNotes && (
                    <ErrorMessage>{errors.driverNotes.message}</ErrorMessage>
                  )}
                </Field>
              </FieldGroup>
            </Fieldset>
          </DialogBody>

          <DialogActions>
            <Button
              plain
              onClick={() => {
                setIsOpen(false);
                resetForm();
              }}
            >
              Annuler
            </Button>
            <Button color="red" type="submit" loading={isPending}>
              Signaler {preview ? "avec photo" : ""}
            </Button>
          </DialogActions>
        </form>
      </Dialog>
    </>
  );
}
