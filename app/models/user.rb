class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
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
  
  def send_password_reset
    begin  
      self[:reset_password_token] = SecureRandom.hex(3)  
    end while User.exists?(column => self[:reset_password_token]) 
    self.reset_password_sent_at = Time.zone.now
    save!
    # TODO: 发送邮件
    UserMailer.reset_password(self.id).deliver
  end
  
end
