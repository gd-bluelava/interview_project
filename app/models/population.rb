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
    year = year.to_i
    min = Population.min
    return 0 if min.nil? || year < min.year

    pop = Population.find_by(year: year)
    unless pop
      max = Population.max
      pop = max if max && year > max.year
      pop = min if pop.nil? && min && year > min.year
    end

    pop&.population
  end
end
