require "rails_helper"

RSpec.describe "Quizzes", type: :request do
  let(:user) { User.create!(username: "testuser", email: "test@example.com", password: "password") }

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
    let(:quiz) { Quiz.create!(title: "First Quiz", description: "This is the first quiz", user: user) }

    it "gets the first quiz" do
      get quiz_path(quiz.id)
      expect(response).to have_http_status(:success)
      expect(response.body).to include("First Quiz")
      expect(response.body).to include("This is the first quiz")
    end
  end

  describe "POST create" do
    before { sign_in user }

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

  describe "POST create with invalid parameters" do
    before { sign_in user }

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

  describe "PATCH update" do
    let(:quiz) { Quiz.create!(title: "First Quiz", description: "This is the first quiz", user: user) }

    before { sign_in user }

    it "sends a PATCH request to update a quiz" do
      patch quiz_path(quiz.id), params: { quiz: { title: "First Quiz", description: "I have updated the quiz" } }
      expect(response).to redirect_to(quiz_path(quiz))
      follow_redirect!
      expect(response).to have_http_status(:success)
      expect(response.body).to include("First Quiz")
      expect(response.body).to include("I have updated the quiz")
    end
  end

  describe "PATCH update with invalid parameters" do
    let(:quiz) { Quiz.create!(title: "Valid Quiz", description: "Valid Description", user: user) }

    before { sign_in user }

    it "does not update the quiz and displays error messages" do
      patch quiz_path(quiz.id), params: { quiz: { title: "", description: "" } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("There were errors with your submission. Please fix them below.")
      expect(response.body).to include("Please enter a title for your quiz")
      expect(response.body).to include("Please provide a description for your quiz")
    end
  end

  describe "DELETE delete" do
    let(:first_quiz) { Quiz.create!(title: "First Quiz", description: "This is the first quiz", user: user) }
    let!(:second_quiz) { Quiz.create!(title: "Second Quiz", description: "This is the second quiz", user: user) }

    before { sign_in user }

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

  describe "unauthorized access" do
    before { sign_in user }

    let(:other_user) { User.create!(username: "otheruser", email: "other@example.com", password: "password") }
    let(:other_quiz) { Quiz.create!(title: "Other Quiz", description: "This quiz belongs to someone else", user: other_user) }

    it "redirects when trying to access the edit page for a quiz not owned by the current user" do
      get edit_quiz_path(other_quiz)
      expect(response).to redirect_to(quiz_path(other_quiz))
      follow_redirect!
      expect(response.body).to include("You are not authorised to perform that action.")
    end

    it "redirects when trying to update a quiz not owned by the current user" do
      patch quiz_path(other_quiz), params: { quiz: { title: "Updated Title", description: "Updated description" } }
      expect(response).to redirect_to(quiz_path(other_quiz))
      follow_redirect!
      expect(response.body).to include("You are not authorised to perform that action.")
    end

    it "redirects when trying to delete a quiz not owned by the current user" do
      delete quiz_path(other_quiz)
      expect(response).to redirect_to(quiz_path(other_quiz))
      follow_redirect!
      expect(response.body).to include("You are not authorised to perform that action.")
    end
  end
end
