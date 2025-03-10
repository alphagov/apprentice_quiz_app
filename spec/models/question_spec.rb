require "rails_helper"

RSpec.describe Question, type: :model do
  describe "#correct_answer" do
    context "when correct_option is valid" do
      it "returns the text for option_a" do
        question = described_class.new(
          content: "Test Question",
          option_a: "Correct A",
          option_b: "Wrong",
          option_c: "Wrong",
          option_d: "Wrong",
          correct_option: "option_a",
        )
        expect(question.correct_answer).to eq("Correct A")
      end
    end

    context "when correct_option is not set" do
      it "raises an exception with 'No answer defined'" do
        question = described_class.new(
          content: "Test Question",
          option_a: "Wrong",
          option_b: "Wrong",
          option_c: "Wrong",
          option_d: "Wrong",
          correct_option: nil,
        )
        expect { question.correct_answer }.to raise_error("No answer defined")
      end
    end
  end
end
