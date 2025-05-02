class LeaderboardEntry < ApplicationRecord
  belongs_to :quiz
  validates :name, presence: true
  validates :score, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
