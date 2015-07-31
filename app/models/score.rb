class Score < ActiveRecord::Base
  belongs_to :player, class_name: "User", foreign_key: "player_id"
  belongs_to :leaderboard
  
  scope :sort_by_value, -> { order('value desc') }
  
  def rank
    Score.where('value > ? and leaderboard_id = ?', value, self.leaderboard.id).count + 1
  end
  
  def as_json(opts = {})
    {
      id: self.id,
      score: self.value || 0,
      rank: self.rank || 0,
      player: self.player || {},
      updated_at: self.updated_at.strftime('%Y-%m-%d %H:%M:%S'),
      # updated_score_ago:  
    }
  end
  
end
