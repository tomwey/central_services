class AddLandscapeImageAndPortraitImageToAds < ActiveRecord::Migration
  def change
    add_column :ads, :landscape_image, :string
    add_column :ads, :portrait_image, :string
  end
end
