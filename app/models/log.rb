class Log < ApplicationRecord
  validates :query, exclusion: { in: [nil] }
  validates :answer, presence: true

  scope :for_dashboard, lambda {
    where.not(query: '').order(created_at: :desc).limit(100)
  }
end
