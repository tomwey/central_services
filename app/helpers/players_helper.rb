module PlayersHelper
  def player_avatar_tag(player)
    if player.blank?
      return image_tag("avatar/small.png", size: '48x48')
    end
    
    if player.avatar.blank?
      return image_tag(player.default_avatar_url, size: '48x48')
    end
    
    image_tag(player.avatar, size: '48x48') 
  end
  
end