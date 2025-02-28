class AddOptionsToQuestions < ActiveRecord::Migration[8.0]
  def change
    add_column :questions, :option_a, :string
    add_column :questions, :option_b, :string
    add_column :questions, :option_c, :string
    add_column :questions, :option_d, :string
    add_column :questions, :correct_option, :string
  end
end
