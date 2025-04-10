require "rails_helper"

RSpec.describe "Quiz Taking", type: :request do
  let(:owner) { User.create!(email: "owner@example.com", password: "password") }
  let(:quiz) { owner.quizzes.create!(title: "Sample Quiz", description: "This is a sample quiz") }

  before do
    quiz.questions.create!(
      content: "What is the GDS?",
      option_a: "Government Digital Service",
      option_b: "Wrong Answer 1",
      option_c: "Wrong Answer 2",
      option_d: "Wrong Answer 3",
      correct_option: "option_a",
    )
    quiz.questions.create!(
      content: "When is Easter?",
      option_a: "March 30th",
      option_b: "April 20th",
      option_c: "May 1st",
      option_d: "December 25th",
      correct_option: "option_b",
    )
  end

  describe "GET guest_prompt" do
    it "renders the guest prompt page" do
      get take_quiz_guest_prompt_path(quiz.id)
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Set Quiz Username")
    end
  end

  describe "POST set_guest_username" do
    context "with a valid guest username" do
      it "sets the guest username in the session and redirects to the first question" do
        post take_quiz_set_guest_username_path(quiz.id), params: { guest_username: "GuestUser" }
        expect(session[:guest_username]).to eq("GuestUser")
        expect(response).to redirect_to(take_quiz_question_path(quiz.id, quiz.questions.first.id))
      end
    end

    context "with a blank guest username" do
      it "redirects back to the guest prompt with an alert" do
        post take_quiz_set_guest_username_path(quiz.id), params: { guest_username: "" }
        expect(response).to redirect_to(take_quiz_guest_prompt_path(quiz.id))
        follow_redirect!
        expect(response.body).to include("Quiz username can&#39;t be blank.")
      end
    end
  end

  describe "GET question" do
    context "when a guest username is set" do
      before do
        post take_quiz_set_guest_username_path(quiz.id), params: { guest_username: "GuestUser" }
      end

      it "displays the current question and form" do
        get take_quiz_question_path(quiz.id, quiz.questions.first.id)
        expect(response).to have_http_status(:success)
        expect(response.body).to include("Sample Quiz")
        expect(response.body).to include("Question 1 of 2")
        expect(response.body).to include("What is the GDS?")
        expect(response.body).to include("Submit Answer")
      end
    end

    context "when a guest username is not set" do
      it "redirects to the guest prompt" do
        get take_quiz_question_path(quiz.id, quiz.questions.first.id)
        expect(response).to have_http_status(:redirect)
        follow_redirect!
        expect(response.body).to include("Please enter a quiz username to continue.")
      end
    end
  end

  describe "POST submit" do
    context "when a guest username is not set" do
      it "redirects to the guest prompt" do
        post take_quiz_submit_path(quiz.id, quiz.questions.first.id), params: { answer: "option_a" }
        expect(response).to have_http_status(:redirect)
        follow_redirect!
        expect(response.body).to include("Please enter a quiz username to continue.")
      end
    end

    context "when a guest username is set" do
      before do
        post take_quiz_set_guest_username_path(quiz.id), params: { guest_username: "GuestUser" }
      end

      context "and there is a next question" do
        it "redirects to the next question" do
          post take_quiz_submit_path(quiz.id, quiz.questions.first.id), params: { answer: "option_a" }
          expect(response).to redirect_to(take_quiz_question_path(quiz.id, quiz.questions.second.id))
        end
      end

      context "and there is no next question" do
        it "redirects to the results page" do
          post take_quiz_submit_path(quiz.id, quiz.questions.second.id), params: { answer: "option_b" }
          expect(response).to redirect_to(take_quiz_results_path(quiz.id))
        end
      end
    end
  end

  describe "GET results" do
    context "when a guest username is not set" do
      it "redirects to the guest prompt" do
        get take_quiz_results_path(quiz.id)
        expect(response).to have_http_status(:redirect)
        follow_redirect!
        expect(response.body).to include("Please enter a quiz username to continue.")
      end
    end

    context "when a guest username is set" do
      before do
        post take_quiz_set_guest_username_path(quiz.id), params: { guest_username: "GuestUser" }
      end

      context "and all answers are correct" do
        before do
          post take_quiz_submit_path(quiz.id, quiz.questions.first.id), params: { answer: "option_a" }
          post take_quiz_submit_path(quiz.id, quiz.questions.second.id), params: { answer: "option_b" }
        end

        it "displays a score of 2 out of 2" do
          get take_quiz_results_path(quiz.id)
          expect(response).to have_http_status(:success)
          expect(response.body).to include("You scored 2 out of 2")
        end
      end

      context "and one answer is incorrect" do
        before do
          post take_quiz_submit_path(quiz.id, quiz.questions.first.id), params: { answer: "option_a" }
          post take_quiz_submit_path(quiz.id, quiz.questions.second.id), params: { answer: "option_a" }
        end

        it "displays a score of 1 out of 2" do
          get take_quiz_results_path(quiz.id)
          expect(response).to have_http_status(:success)
          expect(response.body).to include("You scored 1 out of 2")
        end
      end

      context "and one answer is missing" do
        before do
          post take_quiz_submit_path(quiz.id, quiz.questions.first.id), params: { answer: "option_a" }
        end

        it "displays a score of 1 out of 2" do
          get take_quiz_results_path(quiz.id)
          expect(response).to have_http_status(:success)
          expect(response.body).to include("You scored 1 out of 2")
        end
      end
    end
  end
end
