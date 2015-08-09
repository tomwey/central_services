class AddLangToAds < ActiveRecord::Migration
  def change
    add_column :ads, :lang, :string
  end
end
