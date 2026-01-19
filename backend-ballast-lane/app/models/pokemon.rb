class Pokemon < ApplicationRecord
  self.table_name = "pokemons"

  validates :name, presence: true, uniqueness: true
  validates :number, presence: true, uniqueness: true

  scope :search_by_term, ->(term) {
    return all if term.blank?

    term = term.to_s.strip.downcase
    if term.match?(/^#(\d+)$/)
      # "#004" syntax - exact match on number (strips leading zeros)
      number = term.delete("#").to_i
      where(number: number)
    elsif term.match?(/^\d+$/)
      # Numeric search - partial match
      where("CAST(number AS TEXT) LIKE ?", "%#{term}%")
    else
      # Name search - partial match
      where("name ILIKE ?", "%#{term}%")
    end
  }

  scope :sorted_by, ->(sort, order) {
    column = sort.to_s == "name" ? :name : :number
    direction = order.to_s.downcase == "desc" ? :desc : :asc
    order(column => direction)
  }
end
