require "rails_helper"

RSpec.describe LeaderboardEntry, type: :model do
  subject(:entry) do
    described_class.new(
      name: "GuestUser",
      score: 5,
      quiz: quiz,
    )
  end

  let(:user) { User.create!(email: "test@example.com", password: "password") }
  let(:quiz) { user.quizzes.create!(title: "Example Quiz", description: "Just a test") }

  it "is valid with a name, a non-negative integer score, and a quiz" do
    expect(entry).to be_valid
  end

  context "without a name" do
    before { entry.name = nil }

    it "is invalid" do
      expect(entry).not_to be_valid
      expect(entry.errors[:name]).to include("can't be blank")
    end
  end

  context "without a score" do
    before { entry.score = nil }

    it "is invalid" do
      expect(entry).not_to be_valid
      expect(entry.errors[:score]).to include("can't be blank")
    end
  end

  context "with a non-integer score" do
    before { entry.score = 3.14 }

    it "is invalid" do
      expect(entry).not_to be_valid
      expect(entry.errors[:score]).to include("must be an integer")
    end
  end

  context "with a negative score" do
    before { entry.score = -1 }

    it "is invalid" do
      expect(entry).not_to be_valid
      expect(entry.errors[:score]).to include("must be greater than or equal to 0")
    end
  end
end
