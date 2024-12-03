require "rails_helper"

RSpec.describe "Quizzes", type: :request do
  it "sends a quiz request to create a quiz" do
    expect {
      post "/quizzes", params: { quiz: { title: "First Quiz", description: "This is the first quiz" } }
    }.to change(Quiz, :count).by(1)

    new_quiz = Quiz.last

    expect(response).to redirect_to(quiz_path(new_quiz))
    follow_redirect!

    expect(response).to have_http_status(:success)
    expect(response.body).to include("First Quiz")
    expect(response.body).to include("This is the first quiz")
  end
end
