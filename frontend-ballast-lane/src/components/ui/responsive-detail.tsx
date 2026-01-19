"use client";

import { ArrowLeft, X } from "lucide-react";
import { useIsDesktop } from "@/hooks/use-media-query";
import {
  Dialog,
  DialogContent,
} from "@/components/ui/dialog";
import {
  Drawer,
  DrawerContent,
} from "@/components/ui/drawer";
import { typeColors } from "@/types/pokemon";
import { Icon } from "./icon";

interface ResponsiveDetailProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  title: string;
  description?: string;
  color:  keyof typeof typeColors;
  children: React.ReactNode;
}

export function ResponsiveDetail({
  open,
  onOpenChange,
  title,
  description,
  children,
  color,
}: ResponsiveDetailProps) {
  const isDesktop = useIsDesktop();

  if (isDesktop) {
    return (
      <Drawer open={open} onOpenChange={onOpenChange} direction="right">
        <DrawerContent
          showHandle={false}
          className="fixed inset-y-0 right-0 left-auto h-full w-[400px] rounded-none rounded-l-lg"
        >
          <div className="overflow-y-auto px-4 pb-4 flex-1">{children}</div>
        </DrawerContent>
      </Drawer>
    );
  }

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className={`${typeColors[color]} h-[100dvh] max-h-[100dvh] w-full max-w-full rounded-none p-0 sm:rounded-none`}>
        <div className="flex h-full relative flex-col overflow-hidden">
          <div className={`flex flex-1 overflow-y-auto p-1 ${typeColors[color] || "bg-gray-400"}`}>{children}</div>
        </div>
      </DialogContent>
    </Dialog>
  );
}
