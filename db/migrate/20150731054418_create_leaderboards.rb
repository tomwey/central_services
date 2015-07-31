class CreateLeaderboards < ActiveRecord::Migration
  def change
    create_table :leaderboards do |t|
      t.integer :game_id, :null => false
      t.string :name, :null => false

      t.timestamps
    end
    
    add_index :leaderboards, :game_id
  end
end
