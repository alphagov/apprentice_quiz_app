require "rails_helper"

RSpec.describe "Quizzes", type: :request do
  before do
    login_as(user, scope: :user)
  end

  let(:user) { User.create!(email: "test@example.com", password: "password") }

  describe "GET index" do
    before do
      Quiz.create!(title: "First Quiz", description: "This is the first quiz", user: user)
      Quiz.create!(title: "Second Quiz", description: "This is the second quiz", user: user)
      Quiz.create!(title: "Third Quiz", description: "This is the third quiz", user: user)
      Quiz.create!(title: "Fourth Quiz", description: "This is the fourth quiz", user: user)
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
    context "when the user owns the quiz" do
      let(:quiz) { Quiz.create!(title: "First Quiz", description: "This is the first quiz", user: user) }

      it "gets the quiz successfully" do
        get quiz_path(quiz.id)
        expect(response).to have_http_status(:success)
        expect(response.body).to include("First Quiz")
        expect(response.body).to include("This is the first quiz")
      end
    end

    context "when the user does not own the quiz" do
      let(:other_user) { User.create!(email: "other@example.com", password: "password") }
      let(:other_quiz) { Quiz.create!(title: "Other Quiz", description: "This quiz belongs to someone else", user: other_user) }

      it "redirects to the take quiz page" do
        get quiz_path(other_quiz.id)
        expect(response).to have_http_status(:redirect)
        follow_redirect!
        expect(response).to have_http_status(:success)
        expect(response.body).to include("This quiz is not available because it has no questions.")
      end
    end
  end

  describe "POST create" do
    context "with valid parameters" do
      it "creates a new quiz and redirects to the show page" do
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

    context "with invalid parameters" do
      it "does not create a new quiz and displays error messages" do
        expect {
          post quizzes_path, params: { quiz: { title: "", description: "" } }
        }.not_to change(Quiz, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("There were errors with your submission. Please fix them below.")
        expect(response.body).to include("Please enter a title for your quiz")
        expect(response.body).to include("Please provide a description for your quiz")
      end
    end
  end

  describe "GET edit" do
    context "when the user owns the quiz" do
      let(:quiz) { Quiz.create!(title: "First Quiz", description: "This is the first quiz", user: user) }

      it "renders the edit quiz form with pre-populated values" do
        get edit_quiz_path(quiz)
        expect(response).to have_http_status(:success)
        expect(response.body).to include("Edit a Quiz")
        expect(response.body).to include("First Quiz")
      end
    end

    context "when the user does not own the quiz" do
      let(:other_user) { User.create!(email: "other@example.com", password: "password") }
      let(:other_quiz) { Quiz.create!(title: "Other Quiz", description: "This quiz belongs to someone else", user: other_user) }

      it "returns a not found response" do
        get edit_quiz_path(other_quiz)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "PATCH update" do
    context "when the user owns the quiz and valid parameters are provided" do
      let(:quiz) { Quiz.create!(title: "First Quiz", description: "This is the first quiz", user: user) }

      it "updates the quiz and redirects to the show page" do
        patch quiz_path(quiz), params: { quiz: { title: "First Quiz", description: "I have updated the quiz" } }
        expect(response).to redirect_to(quiz_path(quiz))
        follow_redirect!
        expect(response).to have_http_status(:success)
        expect(response.body).to include("First Quiz")
        expect(response.body).to include("I have updated the quiz")
      end
    end

    context "when invalid parameters are provided" do
      let(:quiz) { Quiz.create!(title: "Valid Quiz", description: "Valid Description", user: user) }

      it "does not update the quiz and displays error messages" do
        patch quiz_path(quiz), params: { quiz: { title: "", description: "" } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("There were errors with your submission. Please fix them below.")
        expect(response.body).to include("Please enter a title for your quiz")
        expect(response.body).to include("Please provide a description for your quiz")
      end
    end

    context "when the user does not own the quiz" do
      let(:other_user) { User.create!(email: "other@example.com", password: "password") }
      let(:other_quiz) { Quiz.create!(title: "Other Quiz", description: "This quiz belongs to someone else", user: other_user) }

      it "returns a not_found response" do
        patch quiz_path(other_quiz), params: { quiz: { title: "Updated Title", description: "Updated description" } }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "DELETE delete" do
    context "when the user owns the quiz" do
      let(:first_quiz) { Quiz.create!(title: "First Quiz", description: "This is the first quiz", user: user) }
      let!(:second_quiz) { Quiz.create!(title: "Second Quiz", description: "This is the second quiz", user: user) }

      it "deletes a quiz and redirects to the quizzes index" do
        expect(second_quiz).to be_present

        delete quiz_path(first_quiz)
        expect(response).to have_http_status(:redirect)

        follow_redirect!
        expect(response).to have_http_status(:success)
        expect(response.body).not_to include("First Quiz")
        expect(response.body).to include("Second Quiz")
      end
    end

    context "when the user does not own the quiz" do
      let(:other_user) { User.create!(email: "other@example.com", password: "password") }
      let(:other_quiz) { Quiz.create!(title: "Other Quiz", description: "This quiz belongs to someone else", user: other_user) }

      it "returns a not found response" do
        delete quiz_path(other_quiz)
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
