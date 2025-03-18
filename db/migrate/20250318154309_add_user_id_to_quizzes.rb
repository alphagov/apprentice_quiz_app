class AddUserIdToQuizzes < ActiveRecord::Migration[8.0]
  class Quiz < ApplicationRecord; end

  def change
    Quiz.delete_all
    # rubocop:disable Rails/NotNullColumn
    add_reference :quizzes, :user, null: false, foreign_key: true
    # rubocop:enable Rails/NotNullColumn
  end
end
