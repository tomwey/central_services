# == Schema Information
#
# Table name: apps
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  icon       :string(255)
#  store_url  :string(255)
#  app_type   :string(255)      not null
#  platform   :string(255)      not null
#  version    :string(255)      not null
#  app_key    :string(255)      not null
#  app_id     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class App < ActiveRecord::Base
  validates :name, :app_type, :platform, :version, presence: true
  # validates_uniqueness_of :secret_key
  
  mount_uploader :icon, AvatarUploader 
  
  before_create :generate_secret_key
  def generate_secret_key
    self.secret_key = SecureRandom.uuid.gsub('-','')
  end
  
  def as_json(opts = {})
    {
      id: self.id,
      icon: self.icon_url,
      store_url: self.store_url,
    }
  end
  
  def icon_url
    self.icon.url(:big) || ""
  end
  
end

