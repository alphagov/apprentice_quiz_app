class Quiz < ApplicationRecord
  has_many :questions, -> { order(:created_at) }, dependent: :destroy
  validates :title, presence: true
  validates :description, presence: true
end
