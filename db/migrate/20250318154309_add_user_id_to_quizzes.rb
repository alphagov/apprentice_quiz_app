class AddUserIdToQuizzes < ActiveRecord::Migration[8.0]
  class Question < ApplicationRecord; end
  class Quiz < ApplicationRecord; end

  def change
    Question.delete_all
    Quiz.delete_all
    # rubocop:disable Rails/NotNullColumn
    add_reference :quizzes, :user, null: false, foreign_key: true
    # rubocop:enable Rails/NotNullColumn
  end
end
