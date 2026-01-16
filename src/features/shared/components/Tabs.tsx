"use client";

import { Tab, TabGroup, TabList, TabPanel, TabPanels } from "@headlessui/react";
import clsx from "clsx";
import { motion } from "framer-motion";
import { useRouter, useSearchParams } from "next/navigation";
import { type ReactNode, useMemo } from "react";
import { Select, TouchTarget } from "@/features/shared/components/index";
// import { DynamicIcon, IconName } from "lucide-react/dynamic";

export type TabItem = {
  id: string;
  label: string;
  iconName?: string;
  panel: ReactNode;
};

type TabsProps = {
  tabs: TabItem[];
};

export function Tabs({ tabs }: TabsProps) {
  const router = useRouter();
  const searchParams = useSearchParams();

  const currentIndex = useMemo(() => {
    const id = decodeURIComponent(searchParams.get("tab") ?? tabs[0].id);
    const idx = tabs.findIndex((t) => t.id === id);
    return idx === -1 ? 0 : idx;
  }, [searchParams, tabs]);

  const setTab = (idx: number) => {
    const params = new URLSearchParams(searchParams.toString());
    params.set("tab", encodeURIComponent(tabs[idx].id));
    router.replace(`?${params}`, { scroll: false });
  };

  return (
    <div>
      <div className="grid grid-cols-1 sm:hidden">
        <Select
          value={tabs[currentIndex].id}
          onChange={(e) =>
            setTab(tabs.findIndex((tab) => tab.id === e.target.value))
          }
        >
          {tabs.map((tab) => (
            <option key={tab.id} value={tab.id}>
              {tab.label}
            </option>
          ))}
        </Select>

        <div className="mt-4">{tabs[currentIndex].panel}</div>
      </div>

      <div className="hidden sm:block">
        <TabGroup selectedIndex={currentIndex} onChange={setTab}>
          <div className="relative">
            <TabList className="flex space-x-6 relative -mx-2 pb-3">
              {tabs.map((tab) => (
                <Tab
                  key={tab.id}
                  className={clsx(
                    "relative cursor-pointer outline-none flex items-center gap-2 rounded-lg px-2 py-2.5 text-sm font-medium text-zinc-950 dark:text-white",
                    "*:companies-[slot=icon]:size-5 *:companies-[slot=icon]:shrink-0 *:companies-[slot=icon]:fill-zinc-500 dark:*:companies-[slot=icon]:fill-zinc-400",
                    "*:last:companies-[slot=icon]:ml-auto *:last:companies-[slot=icon]:size-4",
                    "companies-hover:bg-zinc-950/5 dark:companies-hover:bg-white/5",
                  )}
                >
                  {({ selected }) => (
                    <TouchTarget>
                      {/*{tab.iconName && (*/}
                      {/*  <DynamicIcon*/}
                      {/*    name={tab.iconName}*/}
                      {/*    className="h-4 w-4 text-zinc-950 dark:text-white"*/}
                      {/*  />*/}
                      {/*)}*/}
                      {tab.label}
                      {selected && (
                        <motion.span
                          layoutId="current-indicator"
                          className="absolute inset-x-2 -bottom-2 h-0.5 rounded-full bg-zinc-950 dark:bg-white"
                        />
                      )}
                    </TouchTarget>
                  )}
                </Tab>
              ))}
            </TabList>
          </div>

          <TabPanels className="mt-4">
            {tabs.map((tab) => (
              <TabPanel key={tab.id}>{tab.panel}</TabPanel>
            ))}
          </TabPanels>
        </TabGroup>
      </div>
    </div>
  );
}
