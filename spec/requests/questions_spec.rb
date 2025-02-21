require "rails_helper"

RSpec.describe "Questions", type: :request do
  let!(:quiz) { Quiz.create!(title: "Sample Quiz", description: "This is a sample quiz") }

  describe "GET new" do
    it "renders the new question form" do
      get new_quiz_question_path(quiz)
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Add a New Question")
    end
  end

  describe "POST create" do
    it "creates a new question and redirects to the quiz show page" do
      expect {
        post quiz_questions_path(quiz), params: { question: { content: "One", correct_answer: "Two" } }
      }.to change(quiz.questions, :count).by(1)

      quiz.questions.last
      expect(response).to redirect_to(quiz_path(quiz))
      follow_redirect!
      expect(response).to have_http_status(:success)
      expect(response.body).to include("One")
    end
  end
end
