class Question < ApplicationRecord
  belongs_to :quiz

  def correct_answer_text
    case correct_option
    when "option_a"
      option_a
    when "option_b"
      option_b
    when "option_c"
      option_c
    when "option_d"
      option_d
    else
      "No answer defined"
    end
  end
end
