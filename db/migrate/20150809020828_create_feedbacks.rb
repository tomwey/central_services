class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.string :author
      t.text :content
      t.string :model
      t.string :platform
      t.string :os
      t.string :lang
      t.string :region
      t.string :app_version
      t.string :udid
      t.integer :app_id

      t.timestamps
    end
    add_index :feedbacks, :app_id
    add_index :feedbacks, :udid
  end
end
