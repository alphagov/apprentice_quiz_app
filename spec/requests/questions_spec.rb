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

  describe "GET edit" do
    let!(:question) { quiz.questions.create!(content: "One", correct_answer: "Two") }

    it "renders the edit question form with pre-populated values" do
      get edit_quiz_question_path(quiz, question)
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Edit Question")
      expect(response.body).to include("One")
      expect(response.body).to include("Two")
    end
  end

  describe "PATCH update" do
    let!(:question) { quiz.questions.create!(content: "One", correct_answer: "Two") }

    it "updates the question and redirects to the quiz show page" do
      patch quiz_question_path(quiz, question), params: { question: { content: "Three", correct_answer: "Four" } }
      expect(response).to redirect_to(quiz_path(quiz))
      follow_redirect!
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Three")
      expect(response.body).to include("Four")
    end
  end

  describe "DELETE destroy" do
    let!(:question) { quiz.questions.create!(content: "Delete this", correct_answer: "To be deleted") }

    it "deletes the question and redirects to the quiz show page" do
      expect {
        delete quiz_question_path(quiz, question)
      }.to change(quiz.questions, :count).by(-1)
      expect(response).to redirect_to(quiz_path(quiz))
      follow_redirect!
      expect(response.body).not_to include("Delete this")
    end
  end
end
