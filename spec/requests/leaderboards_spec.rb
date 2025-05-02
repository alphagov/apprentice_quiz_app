require "rails_helper"

RSpec.describe "Leaderboards", type: :request do
  let(:owner) { User.create!(email: "owner@example.com", password: "password") }
  let(:quiz)  { owner.quizzes.create!(title: "Top Quiz", description: "Testing leaderboard") }

  before do
    [
      ["Alice",   1],
      ["Alice",   2],
      ["Bob",     3],
      ["Charlie", 1],
      ["Dave",    0],
      ["Eve",     5],
      ["Frank",   4],
    ].each do |name, score|
      quiz.leaderboard_entries.create!(name: name, score: score)
    end
  end

  describe "GET /quizzes/:id/leaderboard" do
    context "when less than 10 distinct participants exist" do
      it "renders the leaderboard with unique best scores in descending order" do
        get leaderboard_quiz_path(quiz)
        expect(response).to have_http_status(:success)
        expect(response.body).to include("Leaderboard: #{quiz.title}")
        expect(response.body).to include("Rank")
        expect(response.body).to include("Name")
        expect(response.body).to include("Score")

        body = response.body
        idx_eve     = body.index("Eve")
        idx_frank   = body.index("Frank")
        idx_bob     = body.index("Bob")
        idx_alice   = body.index("Alice")
        idx_charlie = body.index("Charlie")
        idx_dave    = body.index("Dave")

        expect(idx_eve).to be < idx_frank
        expect(idx_frank).to be < idx_bob
        expect(idx_bob).to be < idx_alice
        expect(idx_alice).to be < idx_charlie
        expect(idx_charlie).to be < idx_dave
        expect(idx_dave).not_to be_nil
      end
    end

    context "when more than ten distinct participants exist" do
      before do
        %w[Gina Henry Ivy Jack Kelly].each_with_index do |name, idx|
          quiz.leaderboard_entries.create!(name: name, score: idx + 6)
        end
      end

      it "only shows the top 10 scorers and excludes the lowest one" do
        get leaderboard_quiz_path(quiz)
        body = response.body

        expect(body).not_to include("Dave")
        expect(body).to include("Charlie")
      end
    end
  end
end
