class PopulationsController < ApplicationController
  def index
    @year = params[:year].to_i if params[:year]
    @population = Population.get(@year)
  end
end
