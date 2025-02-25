class Quiz < ApplicationRecord
  has_many :questions, -> { order(:id) }, dependent: :destroy
  validates :title, presence: true
  validates :description, presence: true
end
