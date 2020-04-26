class PopulationsController < ApplicationController
  def index
    @year = Population.clamp_year(params[:year])
    @population = Population.get(@year, params[:model])
    Log.log!(@population, params)
  end
end
