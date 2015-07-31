# coding: utf-8
class UserMailer < BaseMailer
  def reset_password(user_id)
    @user = User.find_by(id: user_id)
    return false if @user.blank?
    mail to: @user.email, subject: "获取重置密码验证码"
  end
end