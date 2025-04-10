class Quiz < ApplicationRecord
  belongs_to :user
  has_many :questions, -> { order(:id) }, dependent: :destroy

  validates :title, presence: { message: "Please enter a title for your quiz" }
  validates :description, presence: { message: "Please provide a description for your quiz" }
end
