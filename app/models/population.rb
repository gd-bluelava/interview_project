class Population < ApplicationRecord
  validates :year, :population,
            numericality: { only_integer: true,
                            greater_than_or_equal_to: 0 }
  validates :year, uniqueness: true

  def self.min
    Population.order(:year).first
  end

  def self.max
    Population.order(year: :desc).first
  end

  def self.get(year)
    min = Population.min
    return 0 if min.nil? || year < min.year

    pop = Population.find_by(year: year)
    unless pop
      max = Population.max

      return Population.approximate(year) if max && year.between?(min.year, max.year)

      pop = max if max && year > max.year
      pop = min if pop.nil? && min && year > min.year
    end

    pop&.population
  end

  def self.approximate(year)
    before = Population.where('year <= ?', year).order(:year).first
    after = Population.where('year >= ?', year).order(year: :desc).first
    return unless before && after

    years = after.year - before.year
    per_year = (after.population - before.population) / years.to_f

    before.population + ((year - before.year) * per_year).to_i
  end
end
