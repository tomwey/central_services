class AddSecretKeyToLeaderboards < ActiveRecord::Migration
  def change
    add_column :leaderboards, :secret_key, :string
    add_index :leaderboards, :secret_key, unique: true
  end
end
