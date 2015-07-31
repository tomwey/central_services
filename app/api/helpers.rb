# coding: utf-8
module API
  module APIHelpers
    
    # 获取服务器session
    def session
      env[Rack::Session::Abstract::ENV_SESSION_KEY]
    end
    
    def warden
      env['warden']
    end
    
    # 最大分页大小
    def max_page_size
      100
    end
    
    # 默认分页大小
    def default_page_size
      15
    end
    
    # 分页大小
    def page_size
      size = params[:size].to_i
      size = size.zero? ? default_page_size : size
      [size, max_page_size].min
    end
    
    def render_json(target, grape_entity)
      present target, :with => grape_entity
      body ( { code: 0, message:'ok', data: body } )
    end
    
    # 当前登录用户
    def current_user
      token = params[:token]
      @current_user ||= User.where(private_token: token).first
    end
    
    # 认证用户
    def authenticate!
      error!({"code" => 401, "message" => "用户未登录"}, 200) unless current_user
      error!({"code" => -10, "message" => "您的账号已经被禁用"}, 200) unless current_user.verified
      
      # return { code: 401, message: "用户未登录" } unless current_user
      # return { code: -10, message: "您的账号已经被禁用" } unless current_user.verified
      current_user
    end
    
    # end helpers
  end
end