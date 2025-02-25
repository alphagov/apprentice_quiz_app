require "rails_helper"

RSpec.describe "Quiz Taking", type: :request do
  let(:quiz) { Quiz.create!(title: "Sample Quiz", description: "This is a sample quiz") }

  before do
    quiz.questions.create!(content: "What is the GDS?", correct_answer: "Government Digital Service")
    quiz.questions.create!(content: "When is Easter?", correct_answer: "April 20th")
  end

  describe "GET /quizzes/:id/take/:question_index" do
    it "displays the current question and form" do
      get take_quiz_question_quiz_path(quiz, quiz.questions.first.id)
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Sample Quiz", "Question 1 of 2", "What is the GDS?", "Submit Answer")
    end
  end

  describe "GET /quizzes/:id/results" do
    it "renders the results page with a congratulatory message and navigation button" do
      get results_quiz_quiz_path(quiz)
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Quiz Results")
      expect(response.body).to include("Congratulations, you've completed the quiz")
      expect(response.body).to include("Back to Dashboard")
    end
  end
end
