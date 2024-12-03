require "rails_helper"

RSpec.describe "Quizzes", type: :request do
  before do
    @quiz = Quiz.create(title: "First Quiz", description: "This is the first quiz")
  end

  it "sends a PATCH request to update a quiz" do
    patch "/quizzes/#{@quiz.id}", params: { quiz: { title: "First Quiz", description: "I have updated the quiz" } }

    expect(response).to redirect_to(quiz_path(@quiz))
    follow_redirect!

    expect(response).to have_http_status(:success)
    expect(response.body).to include("First Quiz")
    expect(response.body).to include("I have updated the quiz")
  end
end
