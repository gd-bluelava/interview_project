class Log < ApplicationRecord
  validates :query, exclusion: { in: [nil] }
  validates :answer, presence: true
end
