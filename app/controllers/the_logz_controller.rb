class TheLogzController < ApplicationController
  def index
    @logs = Log.order(created_at: :desc).limit(100)
    @years = Population.select(:year).collect(&:year)
  end

  def exact_queries
    @populations = Population.exact_queries
  end
end
