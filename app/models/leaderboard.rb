class Leaderboard < ActiveRecord::Base
  belongs_to :game, class_name: "App", foreign_key: "game_id"
  has_many :scores
  
  before_create :generate_secret_key
  def generate_secret_key
    self.secret_key = SecureRandom.uuid.gsub('-','')
  end
  
end
