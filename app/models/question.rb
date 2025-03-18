class Question < ApplicationRecord
  belongs_to :quiz

  enum :correct_option, {
    option_a: "option_a",
    option_b: "option_b",
    option_c: "option_c",
    option_d: "option_d",
  }

  validates :content, :option_a, :option_b, :option_c, :option_d, presence: { message: "Field can't be blank" }
  validates :correct_option, inclusion: { in: %w[option_a option_b option_c option_d], message: "Please select one of the options" }

  def correct_answer
    raise "No answer defined" if correct_option.blank?

    public_send(correct_option.to_sym)
  end
end
