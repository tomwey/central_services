class AddPlatformToAppData < ActiveRecord::Migration
  def change
    add_column :app_data, :platform, :string
  end
end
