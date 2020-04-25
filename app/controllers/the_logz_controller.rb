class TheLogzController < ApplicationController
  def index
    @logs = Log.order(created_at: :desc)
    @years = Population.select(:year).collect(&:year)
  end
end
