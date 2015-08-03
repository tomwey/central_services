class AddPrivateTokenToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :private_token, :string
    add_index :players, :private_token, unique: true
  end
end
