class AddUniqueIndexToUsersUsername < ActiveRecord::Migration[8.0]
  def up
    add_index :users, :username, unique: true
  end
end
