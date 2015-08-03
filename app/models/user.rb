# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  private_token          :string(255)
#  nickname               :string(255)
#  avatar                 :string(255)
#  verified               :boolean          default(TRUE)
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  # has_many :authorizations, dependent: :destroy
  
  # validates_presence_of :uid, :provider
  # validates_uniqueness_of :uid, :scope => :provider
  
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
