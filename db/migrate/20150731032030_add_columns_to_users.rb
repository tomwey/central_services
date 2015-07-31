class AddColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :private_token, :string
    add_index :users, :private_token, unique: true
    add_column :users, :nickname, :string
    add_index :users, :nickname, unique: true
    add_column :users, :avatar, :string
    add_column :users, :verified, :boolean, default: true
  end
end
