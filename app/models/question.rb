class Question < ApplicationRecord
  belongs_to :quiz

  enum :correct_option, {
    option_a: "option_a",
    option_b: "option_b",
    option_c: "option_c",
    option_d: "option_d",
  }

  def correct_answer
    raise "No answer defined" if correct_option.blank?

    public_send(correct_option.to_sym)
  end
end
