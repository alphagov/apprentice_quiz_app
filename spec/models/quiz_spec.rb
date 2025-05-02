require "rails_helper"

RSpec.describe Quiz, type: :model do
  let(:user) { User.create!(email: "u@example.com", password: "password") }
  let(:quiz) { user.quizzes.create!(title: "Calculate Score", description: "Test") }

  let!(:first_question) do
    quiz.questions.create!(
      content: "Q1",
      option_a: "A", option_b: "B",
      option_c: "C", option_d: "D",
      correct_option: "option_a"
    )
  end

  let!(:second_question) do
    quiz.questions.create!(
      content: "second_question",
      option_a: "A", option_b: "B",
      option_c: "C", option_d: "D",
      correct_option: "option_b"
    )
  end

  it "returns 2 when all answers correct" do
    answers = { first_question.id.to_s => "option_a", second_question.id.to_s => "option_b" }
    expect(quiz.calculate_score(answers)).to eq(2)
  end

  it "returns 1 when one answer is incorrect" do
    answers = { first_question.id.to_s => "option_a", second_question.id.to_s => "option_c" }
    expect(quiz.calculate_score(answers)).to eq(1)
  end

  it "treats missing answers as incorrect" do
    answers = { first_question.id.to_s => "option_a" }
    expect(quiz.calculate_score(answers)).to eq(1)
  end

  it "returns 0 when no answers provided" do
    expect(quiz.calculate_score({})).to eq(0)
  end
end
