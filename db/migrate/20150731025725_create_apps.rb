class CreateApps < ActiveRecord::Migration
  def change
    create_table :apps do |t|
      t.string :name, :null => false
      t.string :icon
      t.string :store_url
      t.string :app_type, :null => false
      t.string :platform, :null => false
      t.string :version, :null => false
      t.string :app_key, :null => false
      t.string :app_id

      t.timestamps
    end
    
    add_index :apps, :app_key, unique: true
    
  end
end
