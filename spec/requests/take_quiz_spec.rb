require "rails_helper"

RSpec.describe "Quiz Taking", type: :request do
  let(:quiz) { Quiz.create!(title: "Sample Quiz", description: "This is a sample quiz") }

  before do
    quiz.questions.create!(content: "What is the GDS?", correct_answer: "Government Digital Service")
    quiz.questions.create!(content: "When is Easter?", correct_answer: "April 20th")
  end

  describe "GET /take-quiz/:quiz_id/:question_id" do
    it "displays the current question and form" do
      get take_quiz_question_path(quiz.id, quiz.questions.first.id)
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Sample Quiz", "Question 1 of 2", "What is the GDS?", "Submit Answer")
    end
  end

  describe "GET /take-quiz/:quiz_id/results" do
    it "renders the results page with a congratulatory message and navigation button" do
      get take_quiz_results_path(quiz.id)
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Quiz Results")
      expect(response.body).to include("Congratulations, you've completed the quiz")
      expect(response.body).to include("Back to Dashboard")
    end
  end

  describe "POST /take-quiz/:quiz_id/:question_id/submit" do
    context "when there is a next question" do
      it "redirects to the next question" do
        post take_quiz_submit_path(quiz.id, quiz.questions.first.id), params: { answer: "Government Digital Service" }
        expect(response).to redirect_to(take_quiz_question_path(quiz.id, quiz.questions.second.id))
      end
    end

    context "when there is no next question" do
      it "redirects to the results page" do
        post take_quiz_submit_path(quiz.id, quiz.questions.second.id), params: { answer: "April 20th" }
        expect(response).to redirect_to(take_quiz_results_path(quiz.id))
      end
    end
  end
end
