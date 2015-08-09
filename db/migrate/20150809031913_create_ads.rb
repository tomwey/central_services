class CreateAds < ActiveRecord::Migration
  def change
    create_table :ads do |t|
      t.integer :ad_type
      t.string :title
      t.string :message
      t.string :link
      t.string :button_titles

      t.timestamps
    end
  end
end
