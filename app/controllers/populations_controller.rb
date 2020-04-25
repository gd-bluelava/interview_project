class PopulationsController < ApplicationController
  def index
    @year = Population.clamp_year(params[:year])
    @population = Population.get(@year)
    Log.create!(query: params[:year] || '', answer: @population)
  end
end
