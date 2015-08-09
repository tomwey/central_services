# t.string :author
# t.text :content
# t.string :model
# t.string :platform
# t.string :os
# t.string :lang
# t.string :region
# t.string :app_version
# t.string :udid
# t.integer :app_id

class Feedback < ActiveRecord::Base
  
  belongs_to :app
  
  validates_presence_of :content, :model, :platform, :os, :lang, :region, :app_version, :udid, :app_id
end
