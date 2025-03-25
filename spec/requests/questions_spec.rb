require "rails_helper"

RSpec.describe "Questions", type: :request do
  before do
    login_as(user, scope: :user)
  end

  let(:user) { User.create!(email: "test@example.com", password: "password") }
  let(:quiz) { Quiz.create!(title: "Sample Quiz", description: "This is a sample quiz", user: user) }

  describe "GET new" do
    context "when the user owns the quiz" do
      it "renders the new question form" do
        get new_quiz_question_path(quiz)
        expect(response).to have_http_status(:success)
        expect(response.body).to include("Add a New Question")
      end
    end

    context "when the user does not own the quiz" do
      let(:other_user) { User.create!(email: "other@example.com", password: "password") }
      let(:other_quiz) { Quiz.create!(title: "Other Quiz", description: "Another quiz", user: other_user) }

      it "returns a not found response" do
        get new_quiz_question_path(other_quiz)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "POST create" do
    context "when valid parameters are provided" do
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

    context "when invalid parameters are provided" do
      it "does not create a new question and displays error messages" do
        expect {
          post quiz_questions_path(quiz), params: { question: {
            content: "",
            option_a: "Answer A",
            option_b: "Answer B",
            option_c: "Answer C",
            option_d: "Answer D",
            correct_option: "",
          } }
        }.not_to change(quiz.questions, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("There were errors with your submission. Please fix them below.")
        expect(response.body).to include("Field can&#39;t be blank")
        expect(response.body).to include("Please select one of the options")
      end
    end
  end

  describe "GET edit" do
    context "when the user has access to the quiz" do
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

    context "when the user does not have access to the quiz" do
      let(:other_user) { User.create!(email: "other@example.com", password: "password") }
      let(:other_quiz) { Quiz.create!(title: "Other Quiz", description: "Another quiz", user: other_user) }
      let(:question) do
        other_quiz.questions.create!(
          content: "Unauthorized question",
          option_a: "A",
          option_b: "B",
          option_c: "C",
          option_d: "D",
          correct_option: "option_a",
        )
      end

      it "returns a not found response" do
        get edit_quiz_question_path(other_quiz, question)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "PATCH update" do
    context "when valid parameters are provided and the user has access" do
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

    context "when invalid parameters are provided" do
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

      it "does not update the question and re-renders the edit form" do
        patch quiz_question_path(quiz, question), params: { question: {
          content: "",
          option_a: "",
        } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("There were errors with your submission. Please fix them below.")
        expect(response.body.scan("Field can&#39;t be blank").size).to eq(2)
      end
    end

    context "when the user does not have access to the quiz" do
      let(:other_user) { User.create!(email: "other@example.com", password: "password") }
      let(:other_quiz) { Quiz.create!(title: "Other Quiz", description: "Another quiz", user: other_user) }
      let(:question) do
        other_quiz.questions.create!(
          content: "Unauthorized question",
          option_a: "A",
          option_b: "B",
          option_c: "C",
          option_d: "D",
          correct_option: "option_a",
        )
      end

      it "returns a not found response" do
        patch quiz_question_path(other_quiz, question), params: { question: { content: "Updated" } }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "DELETE destroy" do
    context "when the user has access to the quiz" do
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

    context "when the user does not have access to the quiz" do
      let(:other_user) { User.create!(email: "other@example.com", password: "password") }
      let(:other_quiz) { Quiz.create!(title: "Other Quiz", description: "Another quiz", user: other_user) }
      let!(:question) do
        other_quiz.questions.create!(
          content: "Unauthorized question",
          option_a: "A",
          option_b: "B",
          option_c: "C",
          option_d: "D",
          correct_option: "option_a",
        )
      end

      it "returns a not found response" do
        delete quiz_question_path(other_quiz, question)
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
