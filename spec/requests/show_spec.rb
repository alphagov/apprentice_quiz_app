require "rails_helper"

RSpec.describe "Quizzes", type: :request do
  before do
    Quiz.create(title: "First Quiz", description: "This is the first quiz")
    Quiz.create(title: "Second Quiz", description: "This is the second quiz")
    Quiz.create(title: "Third Quiz", description: "This is the third quiz")
    Quiz.create(title: "Fourth Quiz", description: "This is the fourth quiz")
  end

  it "gets the first quiz" do
    get "/quizzes/1"

    expect(response).to have_http_status(:success)
    expect(response.body).to include("First Quiz")
    expect(response.body).to include("This is the first quiz")
  end

  it "gets the second quiz" do
    get "/quizzes/2"

    expect(response).to have_http_status(:success)
    expect(response.body).to include("Second Quiz")
    expect(response.body).to include("This is the second quiz")
  end
end
