"use client";

import confetti, {
  type GlobalOptions as ConfettiGlobalOptions,
  type CreateTypes as ConfettiInstance,
  type Options as ConfettiOptions,
} from "canvas-confetti";
import { useEffect, useRef } from "react";

interface ConfettiProps {
  options?: ConfettiOptions;
  globalOptions?: ConfettiGlobalOptions;
}

export function Confetti({
  options,
  globalOptions = { resize: true, useWorker: true },
}: ConfettiProps) {
  const canvasRef = useRef<HTMLCanvasElement | null>(null);
  const instanceRef = useRef<ConfettiInstance | null>(null);

  useEffect(() => {
    if (!canvasRef.current) return;

    instanceRef.current = confetti.create(canvasRef.current, {
      ...globalOptions,
      resize: true,
    });

    const shoot = () => {
      const count = 10;
      for (let i = 0; i < count; i++) {
        const x = (i + 0.5) / count;
        instanceRef.current?.({
          ...options,
          particleCount: 60,
          spread: 70,
          origin: { x, y: 0.6 },
        });
      }
    };

    shoot();

    return () => {
      instanceRef.current?.reset();
      instanceRef.current = null;
    };
  }, [options, globalOptions]);

  return (
    <canvas
      ref={canvasRef}
      className="fixed inset-0 w-full h-full pointer-events-none"
    />
  );
}
