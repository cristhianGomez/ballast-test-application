"use client";

import { useState, useEffect } from "react";
import { Input } from "@/components/ui/input";
import { Icon } from "@/components/ui/icon";
import {
  Popover,
  PopoverContent,
  PopoverTrigger,
} from "@/components/ui/popover";
import { useDebouncedCallback } from "@/hooks/use-debounce";

interface PokemonFiltersProps {
  search?: string;
  sort?: string;
  order?: "asc" | "desc";
  onFiltersChange: (filters: { search?: string; sort?: string; order?: "asc" | "desc" }) => void;
}

export function PokemonFilters({
  search = "",
  sort = "id",
  order = "asc",
  onFiltersChange,
}: PokemonFiltersProps) {
  const [searchValue, setSearchValue] = useState(search);
  const [isOpen, setIsOpen] = useState(false);

  useEffect(() => {
    setSearchValue(search);
  }, [search]);

  const debouncedSearch = useDebouncedCallback((value: string) => {
    onFiltersChange({ search: value || undefined, sort, order });
  }, 300);

  const handleSearchChange = (value: string) => {
    setSearchValue(value);
    debouncedSearch(value);
  };

  const handleSortChange = (value: string) => {
    onFiltersChange({ search: searchValue || undefined, sort: value, order });
    setIsOpen(false);
  };

  const getSortIcon = () => {
    if (sort === "name") return "text-format";
    return "tag";
  };

  return (
    <div className="m-3 mb-6 flex items-center gap-3">
      {/* Search Input */}
      <div className="flex-1 relative">
        <Icon
          name="search"
          size={16}
          color="#DC0A2D"
          className="absolute left-3 top-1/2 -translate-y-1/2 pointer-events-none"
        />
        <Input
          placeholder="Search"
          name="search"
          value={searchValue}
          onChange={(e) => handleSearchChange(e.target.value)}
          className="pl-9 pr-4 bg-white rounded-full placeholder:text-grayscale-medium shadow-inner-2"
        />
      </div>

      {/* Sort Button with Popover */}
      <Popover open={isOpen} onOpenChange={setIsOpen}>
        <PopoverTrigger asChild>
          <button
            className="flex items-center justify-center w-8 h-8 bg-white rounded-full shadow-inner-2 hover:bg-gray-50 transition-colors"
            aria-label="Sort options"
          >
            <Icon
              name={getSortIcon()}
              size={16}
              color="#DC0A2D"
            />
          </button>
        </PopoverTrigger>
        <PopoverContent
          className="w-[113px] p-1 shadow-drop-2 rounded-xl border-0"
          align="end"
          sideOffset={8}
        >
          <div className="space-y-1">
            {/* Title */}
            <p className="text-primary text-subtitle-3 px-3 pt-2">Sort by:</p>

            {/* Number Option */}
            <button
              onClick={() => handleSortChange("id")}
              className="flex items-center gap-2 w-full px-3 py-1 hover:bg-gray-50 rounded-lg transition-colors"
            >
              <Icon
                name={sort === "id" ? "radio-selected" : "radio"}
                size={16}
                color="#DC0A2D"
              />
              <span className="text-body-3 text-grayscale-dark">Number</span>
            </button>

            {/* Name Option */}
            <button
              onClick={() => handleSortChange("name")}
              className="flex items-center gap-2 w-full px-3 py-1 pb-2 hover:bg-gray-50 rounded-lg transition-colors"
            >
              <Icon
                name={sort === "name" ? "radio-selected" : "radio"}
                size={16}
                color="#DC0A2D"
              />
              <span className="text-body-3 text-grayscale-dark">Name</span>
            </button>
          </div>
        </PopoverContent>
      </Popover>
    </div>
  );
}
