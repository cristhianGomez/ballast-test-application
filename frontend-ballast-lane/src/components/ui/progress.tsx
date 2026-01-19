"use client"

import * as React from "react"
import * as ProgressPrimitive from "@radix-ui/react-progress"

import { cn } from "@/lib/utils"
import { textColors } from "@/types/pokemon"


const Progress = React.forwardRef<
React.ElementRef<typeof ProgressPrimitive.Root>,
React.ComponentPropsWithoutRef<typeof ProgressPrimitive.Root>
>(({ className, value, color, ...props }, ref) => {
  const colorGradient = `${color}/20`;
  
  return (
  <ProgressPrimitive.Root
    ref={ref}
    className={cn(
      `relative h-1 w-full overflow-hidden rounded-full`,
      className
    )}
    {...props}
  >
    
    <ProgressPrimitive.Indicator
      className={cn(`absolute right-0 h-full w-full flex-1 transition-all opacity-20`, color)}
    />
    <ProgressPrimitive.Indicator
      className={cn(`h-full w-full flex-1 transition-all`, color)}
      style={{ transform: `translateX(-${100 - (value || 0)}%)` }}
    />
  </ProgressPrimitive.Root>
)})
Progress.displayName = ProgressPrimitive.Root.displayName

export { Progress }
