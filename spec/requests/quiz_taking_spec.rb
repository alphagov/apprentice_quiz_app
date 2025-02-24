require "rails_helper"

RSpec.describe "Quiz Taking", type: :request do
  let(:quiz) { Quiz.create!(title: "Sample Quiz", description: "This is a sample quiz") }
  let!(:question1) { quiz.questions.create!(content: "What is the GDS?", correct_answer: "Government Digital Service") }
  let!(:question2) { quiz.questions.create!(content: "When is Easter?", correct_answer: "April 20th") }

  describe "GET /quizzes/:id/take/:question_index" do
    it "displays the current question and form" do
      get take_quiz_path(quiz, 0)
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Sample Quiz", "Question 1 of 2", "What is the GDS?", "Submit Answer")
    end
  end
end
