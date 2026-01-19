"use client";

import { ChevronLeft, ChevronRight } from "lucide-react";
import { Button } from "@/components/ui/button";

interface PokemonPaginationProps {
  currentPage: number;
  totalCount: number;
  limit: number;
  onPageChange: (page: number) => void;
}

export function PokemonPagination({
  currentPage,
  totalCount,
  limit,
  onPageChange,
}: PokemonPaginationProps) {
  const totalPages = Math.ceil(totalCount / limit);
  const hasPreviousPage = currentPage > 1;
  const hasNextPage = currentPage < totalPages;

  const getPageNumbers = () => {
    const pages: (number | "...")[] = [];
    const maxVisible = 5;

    if (totalPages <= maxVisible) {
      for (let i = 1; i <= totalPages; i++) {
        pages.push(i);
      }
    } else {
      pages.push(1);

      if (currentPage > 3) {
        pages.push("...");
      }

      const start = Math.max(2, currentPage - 1);
      const end = Math.min(totalPages - 1, currentPage + 1);

      for (let i = start; i <= end; i++) {
        pages.push(i);
      }

      if (currentPage < totalPages - 2) {
        pages.push("...");
      }

      pages.push(totalPages);
    }

    return pages;
  };

  if (totalPages <= 1) {
    return null;
  }

  return (
    <div className="flex items-center justify-center gap-0.5 sm:gap-1 mx-2 sm:mx-4">
      <Button
        variant="outline"
        size="icon"
        onClick={() => onPageChange(currentPage - 1)}
        disabled={!hasPreviousPage}
        className="h-7 w-7 sm:h-8 sm:w-8"
      >
        <ChevronLeft className="h-3 w-3 sm:h-4 sm:w-4" />
        <span className="sr-only">Previous</span>
      </Button>

      {getPageNumbers().map((page, index) =>
        page === "..." ? (
          <span key={`ellipsis-${index}`} className="px-1 sm:px-2 text-muted-foreground text-xs sm:text-sm">
            ...
          </span>
        ) : (
          <Button
            key={page}
            variant={currentPage === page ? "default" : "outline"}
            size="sm"
            onClick={() => onPageChange(page)}
            className="h-7 w-7 sm:h-8 sm:min-w-[36px] text-xs sm:text-sm p-0 sm:px-3"
          >
            {page}
          </Button>
        )
      )}

      <Button
        variant="outline"
        size="icon"
        onClick={() => onPageChange(currentPage + 1)}
        disabled={!hasNextPage}
        className="h-7 w-7 sm:h-8 sm:w-8"
      >
        <ChevronRight className="h-3 w-3 sm:h-4 sm:w-4" />
        <span className="sr-only">Next</span>
      </Button>
    </div>
  );
}
