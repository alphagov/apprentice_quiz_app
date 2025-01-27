class Quiz < ApplicationRecord
  has_many :questions, dependent: :destroy
  validates :title, presence: true
  validates :description, presence: true
end
