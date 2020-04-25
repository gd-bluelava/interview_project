class TheLogzController < ApplicationController
  before_action :logs_and_years, only: %i[index update_population_queries]

  def index; end

  def update_population_queries; end

  def exact_queries
    @populations = Population.exact_queries
  end

  private

  def logs_and_years
    @logs = Log.for_dashboard
    @years = Population.years
  end
end
