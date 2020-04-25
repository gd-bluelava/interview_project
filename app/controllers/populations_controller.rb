class PopulationsController < ApplicationController
  def index; end

  def show
    @year = params[:year].to_i
    @population = Population.get(@year)
  end
end
