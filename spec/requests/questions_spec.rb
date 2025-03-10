require "rails_helper"

RSpec.describe "Questions", type: :request do
  let(:quiz) { Quiz.create!(title: "Sample Quiz", description: "This is a sample quiz") }

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
        post quiz_questions_path(quiz), params: { question: {
          content: "One",
          option_a: "Answer A",
          option_b: "Answer B",
          option_c: "Answer C",
          option_d: "Answer D",
          correct_option: "option_a",
        } }
      }.to change(quiz.questions, :count).by(1)

      expect(response).to redirect_to(quiz_path(quiz))
      follow_redirect!
      expect(response).to have_http_status(:success)
      expect(response.body).to include("One")
    end
  end

  describe "GET edit" do
    let(:question) do
      quiz.questions.create!(
        content: "One",
        option_a: "Answer A",
        option_b: "Answer B",
        option_c: "Answer C",
        option_d: "Answer D",
        correct_option: "option_a",
      )
    end

    it "renders the edit question form with pre-populated values" do
      get edit_quiz_question_path(quiz, question)
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Edit Question")
                           .and include("One")
                           .and include("Answer A")
    end
  end

  describe "PATCH update" do
    let(:question) do
      quiz.questions.create!(
        content: "One",
        option_a: "Answer A",
        option_b: "Answer B",
        option_c: "Answer C",
        option_d: "Answer D",
        correct_option: "option_a",
      )
    end

    it "updates the question and redirects to the quiz show page" do
      patch quiz_question_path(quiz, question), params: { question: {
        content: "Three",
        option_a: "Four", # updating option_a to "Four" as the new correct answer
        option_b: "Answer B",
        option_c: "Answer C",
        option_d: "Answer D",
        correct_option: "option_a",
      } }
      expect(response).to redirect_to(quiz_path(quiz))
      follow_redirect!
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Three")
      expect(response.body).to include("Four")
    end
  end

  describe "DELETE destroy" do
    let!(:question) do
      quiz.questions.create!(
        content: "Delete this",
        option_a: "To be deleted",
        option_b: "Dummy",
        option_c: "Dummy",
        option_d: "Dummy",
        correct_option: "option_a",
      )
    end

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
