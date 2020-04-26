class Log < ApplicationRecord
  validates :query, exclusion: { in: [nil] }
  validates :answer, presence: true

  scope :for_dashboard, lambda {
    where.not(query: '').order(created_at: :desc).limit(100)
  }

  def self.log!(population, params)
    return unless params[:year]

    algo = params && params[:model] ? Population::ALGOS.find_index(params[:model]) : 0
    Log.create!(query: params[:year], answer: population, algo: algo)
  end
end
