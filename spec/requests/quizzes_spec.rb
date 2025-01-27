require "rails_helper"

RSpec.describe "Quizzes", type: :request do
  describe "GET index" do
    before do
      Quiz.create!(title: "First Quiz", description: "This is the first quiz")
      Quiz.create!(title: "Second Quiz", description: "This is the second quiz")
      Quiz.create!(title: "Third Quiz", description: "This is the third quiz")
      Quiz.create!(title: "Fourth Quiz", description: "This is the fourth quiz")
    end

    it "gets all quizzes and checks the content" do
      get "/quizzes"
      expect(response).to have_http_status(:success)
      expect(response.body).to include("First Quiz")
      expect(response.body).to include("Second Quiz")
      expect(response.body).to include("Third Quiz")
      expect(response.body).to include("Fourth Quiz")
    end
  end

  describe "GET show" do
    before do
      @quiz = Quiz.create!(title: "First Quiz", description: "This is the first quiz")
    end

    it "gets the first quiz" do
      get quiz_path(@quiz.id)

      expect(response).to have_http_status(:success)
      expect(response.body).to include("First Quiz")
      expect(response.body).to include("This is the first quiz")
    end
  end

  describe "POST create" do
    it "sends a quiz request to create a quiz" do
      expect {
        post quizzes_path, params: { quiz: { title: "First Quiz", description: "This is the first quiz" } }
      }.to change(Quiz, :count).by(1)

      new_quiz = Quiz.last

      expect(response).to redirect_to(quiz_path(new_quiz))
      follow_redirect!

      expect(response).to have_http_status(:success)
      expect(response.body).to include("First Quiz")
      expect(response.body).to include("This is the first quiz")
    end
  end

  describe "PATCH update" do
    before do
      @quiz = Quiz.create!(title: "First Quiz", description: "This is the first quiz")
    end

    it "sends a PATCH request to update a quiz" do
      patch quiz_path(@quiz.id), params: { quiz: { title: "First Quiz", description: "I have updated the quiz" } }

      expect(response).to redirect_to(quiz_path(@quiz))
      follow_redirect!

      expect(response).to have_http_status(:success)
      expect(response.body).to include("First Quiz")
      expect(response.body).to include("I have updated the quiz")
    end
  end

  describe "DELETE delete" do
    before do
      Quiz.create!(title: "First Quiz", description: "This is the first quiz")
      Quiz.create!(title: "Second Quiz", description: "This is the second quiz")
    end

    it "deletes a quiz and redirects to the quizzes index" do
      delete quiz_path(1)
      expect(response).to have_http_status(:redirect)

      follow_redirect!
      expect(response).to have_http_status(:success)
      expect(response.body).not_to include("First Quiz")
      expect(response.body).to include("Second Quiz")
    end
  end
end
