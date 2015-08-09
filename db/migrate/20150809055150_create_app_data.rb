class CreateAppData < ActiveRecord::Migration
  def change
    create_table :app_data do |t|
      t.string :udid
      t.string :app_version
      t.string :device_model
      t.string :os_version
      t.string :language_code
      t.string :country_code
      t.string :from_market
      t.string :screen_size
      t.integer :app_id

      t.timestamps
    end
    add_index :app_data, :app_id
    add_index :app_data, :udid
  end
end
