class TheLogzController < ApplicationController
  def index
    @logs = Log.order(created_at: :desc)
  end
end
