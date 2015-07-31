class App < ActiveRecord::Base
  validates :name, :app_type, :platform, :version, :app_key, presence: true
  validates_uniqueness_of :app_key
  
  before_create :generate_app_key
  def generate_app_key
    self.app_key = SecureRandom.uuid.gsub('-','')
  end
  
end
