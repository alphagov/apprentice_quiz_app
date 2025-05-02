class CreateLeaderboardEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :leaderboard_entries do |t|
      t.string :name
      t.references :quiz, null: false, foreign_key: true
      t.integer :score

      t.timestamps
    end
  end
end
