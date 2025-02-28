class Question < ApplicationRecord
  belongs_to :quiz

  validates :content, :option_a, :option_b, :option_c, :option_d, :correct_option, presence: true
  validates :correct_option, inclusion: {
    in: %w[option_a option_b option_c option_d],
    message: "must be one of option_a, option_b, option_c, or option_d",
  }
end
