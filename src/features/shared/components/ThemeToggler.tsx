"use client";

import clsx from "clsx";
import { Moon, SunDim } from "lucide-react";
import { type PropsWithChildren, useRef, useState } from "react";
import { flushSync } from "react-dom";
import { Button } from "@/features/shared/components/index";

type props = PropsWithChildren<{
  className?: string;
}>;

export const ThemeToggler = ({ className, children }: props) => {
  const [isDarkMode, setIsDarkMode] = useState<boolean>(false);
  const buttonRef = useRef<HTMLButtonElement | null>(null);

  const changeTheme = async () => {
    if (!buttonRef.current) return;

    await document.startViewTransition(() => {
      flushSync(() => {
        const html = document.documentElement;
        const currentTheme = html.getAttribute("data-theme");
        const nextTheme = currentTheme === "dark" ? "light" : "dark";

        html.setAttribute("data-theme", nextTheme);
        setIsDarkMode(nextTheme === "dark");
      });
    }).ready;

    const { top, left, width, height } =
      buttonRef.current.getBoundingClientRect();
    const y = top + height / 2;
    const x = left + width / 2;

    const right = window.innerWidth - left;
    const bottom = window.innerHeight - top;
    const maxRad = Math.hypot(Math.max(left, right), Math.max(top, bottom));

    document.documentElement.animate(
      {
        clipPath: [
          `circle(0px at ${x}px ${y}px)`,
          `circle(${maxRad}px at ${x}px ${y}px)`,
        ],
      },
      {
        duration: 700,
        easing: "ease-in-out",
        pseudoElement: "::view-transition-new(root)",
      },
    );
  };

  return (
    <Button
      plain
      ref={buttonRef}
      onClick={changeTheme}
      className={clsx(className)}
    >
      {isDarkMode ? (
        <SunDim className="h-5 w-5" />
      ) : (
        <Moon className="h-5 w-5" />
      )}
      {children}
    </Button>
  );
};
