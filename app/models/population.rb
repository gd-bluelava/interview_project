class Population < ApplicationRecord
  MAX_YEAR = 2500
  ALGOS = %w[None Logistical Exponential].freeze

  validates :year, :population,
            numericality: {only_integer: true,
                           greater_than_or_equal_to: 0}
  validates :year, uniqueness: true

  scope :exact_queries, lambda {
    select('populations.*', 'COUNT(logs.id) AS queries')
        .joins('LEFT JOIN logs ON populations.year = logs.query::integer')
        .group('populations.id')
  }

  scope :years, lambda {
    select(:year).collect(&:year)
  }

  def self.min
    Population.order(:year).first
  end

  def self.max
    Population.order(year: :desc).first
  end

  def self.get(year, model)
    return 0 unless year

    min = Population.min
    return 0 if min.nil? || year < min.year

    pop = Population.find_by(year: year)
    unless pop
      max = Population.max
      if max
        if year > max.year
          return model == 'Exponential' ? Population.exponential(year) : Population.logistical(year)
        else
          return Population.approximate(year) if year.between?(min.year, max.year)
        end
      end

      pop = max if max && year > max.year
      pop = min if pop.nil? && min && year > min.year
    end

    pop&.population
  end

  def self.logistical(year)
    p = Population.max
    p0 = p.population

    t = year - p.year
    k = 750_000_000
    r = 0.09

    # https://www.fxsolver.com/browse/formulas/Population+growth+rate+-+Logistic+equation
    pop = k / (1 + (((k - p0) / p0) * Math.exp(-r * t)))
    pop.to_i
  end

  def self.exponential(year)
    p = Population.max
    p_year = p.year
    population = p.population
    while p_year < year
      p_year += 1
      population += (population * 0.09).to_i
    end
    population
  end

  def self.approximate(year)
    before = Population.where('year <= ?', year).order(:year).first
    after = Population.where('year >= ?', year).order(year: :desc).first
    return unless before && after

    years = after.year - before.year
    per_year = (after.population - before.population) / years.to_f

    before.population + ((year - before.year) * per_year).to_i
  end

  def self.clamp_year(year)
    return unless year.present?

    y = year.to_i
    y = 0 if y.negative?
    y > MAX_YEAR ? MAX_YEAR : y
  end
end
