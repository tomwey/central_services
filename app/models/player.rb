class Player < ActiveRecord::Base
  validates_presence_of :uid, :provider, :nickname
  validates_uniqueness_of :uid, :scope => :provider
  
  mount_uploader :avatar, AvatarUploader 
  
  def ensure_private_token!
    self.update_private_token if self.private_token.blank?
  end
  
  def update_private_token
    random_key = "#{SecureRandom.hex(10)}:#{self.id}"
    self.update_attribute(:private_token, random_key)
  end
  
  def avatar_url
    self.avatar.url(:big) || ""
  end
  
  def as_json(opts = {})
    {
      id: self.id,
      nickname: self.nickname || "",
      token: self.private_token || "",
      avatar: self.avatar_url,
    }
  end
  
end
