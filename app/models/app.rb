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
  validates :name, :app_type, :platform, :version, :app_key, presence: true
  validates_uniqueness_of :app_key
  
  before_create :generate_app_key
  def generate_app_key
    self.app_key = SecureRandom.uuid.gsub('-','')
  end
  
end

