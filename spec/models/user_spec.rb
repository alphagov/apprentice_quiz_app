require "rails_helper"

RSpec.describe User, type: :model do
  subject(:user) do
    described_class.new(
      email: "test@example.com",
      password: "password",
    )
  end

  describe "validations" do
    it "is valid with valid attributes" do
      expect(user).to be_valid
    end

    it "is not valid without an email" do
      user.email = nil
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it "is not valid with a duplicate email" do
      user.save!
      duplicate_user = described_class.new(
        email: user.email,
        password: "password",
      )
      expect(duplicate_user).not_to be_valid
      expect(duplicate_user.errors[:email]).to include("has already been taken")
    end
  end

  describe "Devise modules" do
    it "responds to valid_password?" do
      expect(user).to respond_to(:valid_password?)
    end
  end
end
