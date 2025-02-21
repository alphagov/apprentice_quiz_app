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
end
