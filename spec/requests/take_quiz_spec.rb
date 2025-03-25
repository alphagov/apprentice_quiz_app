require "rails_helper"

RSpec.describe "Quiz Taking", type: :request do
  let(:owner) { User.create!(username: "owner", email: "owner@example.com", password: "password") }
  let(:quiz) { owner.quizzes.create!(title: "Sample Quiz", description: "This is a sample quiz") }

  context "when a guest has a username set" do
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
      post take_quiz_set_guest_username_path(quiz.id), params: { guest_username: "GuestUser" }
    end

    describe "GET /take-quiz/:quiz_id/:question_id" do
      it "displays the current question and form" do
        get take_quiz_question_path(quiz.id, quiz.questions.first.id)
        expect(response).to have_http_status(:success)
        expect(response.body).to include("Sample Quiz")
        expect(response.body).to include("Question 1 of 2")
        expect(response.body).to include("What is the GDS?")
        expect(response.body).to include("Submit Answer")
      end
    end

    describe "GET /take-quiz/:quiz_id/results" do
      it "renders the results page with a congratulatory message, guest username and navigation button" do
        get take_quiz_results_path(quiz.id)
        expect(response).to have_http_status(:success)
        expect(response.body).to include("Quiz Results")
        expect(response.body).to include("Congratulations, you've completed the quiz")
        expect(response.body).to include("Back to Dashboard")
        expect(response.body).to include("GuestUser")
      end
    end

    describe "POST /take-quiz/:quiz_id/:question_id/submit" do
      context "when there is a next question" do
        it "redirects to the next question" do
          post take_quiz_submit_path(quiz.id, quiz.questions.first.id), params: { answer: "option_a" }
          expect(response).to redirect_to(take_quiz_question_path(quiz.id, quiz.questions.second.id))
        end
      end

      context "when there is no next question" do
        it "redirects to the results page" do
          post take_quiz_submit_path(quiz.id, quiz.questions.second.id), params: { answer: "option_b" }
          expect(response).to redirect_to(take_quiz_results_path(quiz.id))
        end
      end
    end

    describe "Quiz scoring" do
      context "when all answers are correct" do
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

      context "when one answer is incorrect" do
        before do
          post take_quiz_submit_path(quiz.id, quiz.questions.first.id), params: { answer: "option_a" }
          post take_quiz_submit_path(quiz.id, quiz.questions.second.id), params: { answer: "option_a" } # incorrect for question 2
        end

        it "displays a score of 1 out of 2" do
          get take_quiz_results_path(quiz.id)
          expect(response).to have_http_status(:success)
          expect(response.body).to include("You scored 1 out of 2")
        end
      end

      context "when one answer is missing" do
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

  context "when a guest does not have a username set" do
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

    describe "GET /take-quiz/:quiz_id/:question_id" do
      it "prompts the user to enter their guest username" do
        get take_quiz_question_path(quiz.id, quiz.questions.first.id)
        expect(response).to have_http_status(:redirect)
        follow_redirect!
        expect(response).to have_http_status(:success)
        expect(response.body).to include("Please enter your guest username to continue.")
      end
    end
  end
end
