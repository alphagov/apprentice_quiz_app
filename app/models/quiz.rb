class Quiz < ApplicationRecord
  belongs_to :user
  has_many :questions, -> { order(:id) }, dependent: :destroy
  has_many :leaderboard_entries, dependent: :destroy

  validates :title, presence: { message: "Please enter a title for your quiz" }
  validates :description, presence: { message: "Please provide a description for your quiz" }

  def calculate_score(answers = {})
    questions.sum do |q|
      answers[q.id.to_s] == q.correct_option ? 1 : 0
    end
  end
end
