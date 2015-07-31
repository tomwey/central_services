class Leaderboard < ActiveRecord::Base
  belongs_to :game, class_name: "App", foreign_key: "game_id"
  has_many :scores
  
end
