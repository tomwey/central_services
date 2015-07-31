class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.integer :leaderboard_id
      t.integer :player_id
      t.integer :value

      t.timestamps
    end
    add_index :scores, :leaderboard_id
    add_index :scores, :player_id
  end
end
