module API
  class UsersAPI < Grape::API
    
    resource :account do
      
      # 用户注册
      params do
        requires :email, type: String, desc: "邮箱"
        requires :password, type: String, desc: "密码"
        optional :nickname, type: String, desc: "昵称"
      end
      
      post :sign_up do
        
        # 邮箱检测
        @user = User.find_by(email: params[:email])
        unless @user.blank?
          return { code: 1001, message: "#{params[:email]}已经注册" }
        end
        
        # 昵称检测
        @user = User.find_by(nickname: params[:nickname])
        unless @user.blank?
          return { code: 1002, message: "#{params[:nickname]}已经被占用" }
        end
        
        # 密码检测
        if params[:password].length < 6
          return { code: 1003, message: "密码太短，至少为6位" }
        end
        
        # 注册
        @user = User.new(email: params[:email], password: params[:password], nickname: params[:nickname])
        if @user.save
          warden.set_user(@user)
          @user.ensure_private_token!
          
          render_json(@user, API::Entities::User)
        else
          { code: 1004, message: "用户注册失败！" }
        end
        
      end # end sign_up
      
      # 用户登录
      params do 
        requires :login, type: String, desc: "登录名"
        requires :password, type: String, desc: "密码"
      end
      post :login do
        @user = User.where('lower(email) = :value', value: params[:login].downcase).first
        if @user.blank?
          return { code: 1005, message: "该用户还未注册" }
        end
        
        if @user.valid_password?(password)
          render_json(@user, API::Entities::User)
        else
          { code: 1006, message: "登录密码不正确" }
        end
      end # end login
      
      # 退出登陆
      params do
        requires :token, type: String, desc: "Token"
      end
      post :logout do
        authenticate!
        
        warden.logout
        { code: 0, message: "ok" }
      end # end logout
      
      # 忘记密码
      params do
        requires :email, type: String, desc: "邮箱"
      end
      post '/password/forget' do
        @user = User.find_by(email: params[:email])
        if @user.blank?
          return { code: 1007, message: "账号不存在" }
        end
        
        @user.send_password_reset
        { code: 0, message: "ok" }
      end # end password forget
      
      # 重置密码
      params do
        requires :code, type: String, desc: "重置验证码"
        requires :password, type: String, desc: "新密码"
      end
      post '/password/reset' do
        @user = User.find_by(reset_password_token: params[:code])
        
        if @user.blank?
          return { code: 1008, message: "重置验证码不正确" }
        end
        
        if params[:password].length < 6
          return { code: 1003, message: "密码太短，至少为6位" }
        end
        
        if @user.reset_password_sent_at < 2.hours.ago
          { code: 1009, message: "重置验证码已过期" }
        elsif @user.update_attribute(:password, params[:password])
          { code: 0, message: "ok" }
        else
          { code: 1010, message: "重置密码失败" }
        end
      end # end reset password

    end # end account resource
    
    resource :user do
      # 获取用户个人资料
      params do
        requires :token, type: String, desc: "Token"
      end
      get :me do
        user = authenticate!
        
        render_json(user, API::Entities::User)
      end # end me
      
      # 修改个人资料
      params do
        requires :token, type: String, desc: "Token"
        optional :nickname, type: String, desc: "昵称"
        optional :avatar, desc: "头像图片数据"
      end
      post :update_profile do
        user = authenticate!
        
        if params[:nickname]
          user.nickname = params[:nickname]
        end
        
        if params[:avatar]
          user.avatar = params[:avatar]
        end
        
        if user.save
          { code: 0, message: "ok" }
        else
          { code: 1011, message: user.errors.full_messages.join(',') }
        end
        
      end # end update profile
      
    end # end user resource
    
  end
end