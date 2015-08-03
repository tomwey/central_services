class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :nickname, :null => false
      t.string :avatar
      t.string :uid,      :null => false
      t.string :provider, :null => false

      t.timestamps
    end
  end
end
