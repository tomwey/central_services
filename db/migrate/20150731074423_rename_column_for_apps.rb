class RenameColumnForApps < ActiveRecord::Migration
  def change
    remove_index :apps, :app_key
    remove_column :apps, :app_key
    
    add_column :apps, :secret_key, :string
    add_index :apps, :secret_key, unique: true
  end
end
