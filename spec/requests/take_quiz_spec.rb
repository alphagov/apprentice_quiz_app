require "rails_helper"

RSpec.describe "Quiz Taking", type: :request do
  let(:quiz) { Quiz.create!(title: "Sample Quiz", description: "This is a sample quiz") }

  before do
    quiz.questions.create!(
      content: "What is the GDS?",
      option_a: "Government Digital Service",
      option_b: "Global Distribution System",
      option_c: "Good Data Setup",
      option_d: "Generic Data Service",
      correct_option: "option_a",
    )
    quiz.questions.create!(
      content: "When is Easter?",
      option_a: "April 20th",
      option_b: "Never",
      option_c: "January 1st",
      option_d: "December 25th",
      correct_option: "option_a",
    )
  end

  describe "GET /take-quiz/:quiz_id/:question_id" do
    it "displays the current question and form" do
      get take_quiz_question_path(quiz.id, quiz.questions.first.id)
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Sample Quiz")
      expect(response.body).to include("What is the GDS?")
      expect(response.body).to include("Submit Answer")
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
        post take_quiz_submit_path(quiz.id, quiz.questions.first.id), params: { answer: "option_a" }
        expect(response).to redirect_to(take_quiz_question_path(quiz.id, quiz.questions.second.id))
      end
    end

    context "when there is no next question" do
      it "redirects to the results page" do
        post take_quiz_submit_path(quiz.id, quiz.questions.second.id), params: { answer: "option_a" }
        expect(response).to redirect_to(take_quiz_results_path(quiz.id))
      end
    end
  end
end
