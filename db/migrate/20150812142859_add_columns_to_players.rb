class AddColumnsToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :udid, :string
    add_column :players, :model, :string
    add_column :players, :os_version, :string
    add_column :players, :platform, :string
    add_column :players, :language_code, :string
    add_column :players, :country_code, :string
    add_column :players, :screen_size, :string
  end
end
