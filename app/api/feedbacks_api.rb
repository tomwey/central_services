module API
  class FeedbacksAPI < Grape::API    
    resource :feedbacks do
      params do
        requires :body,    type: String, desc: "意见反馈内容"
        requires :model,   type: String, desc: "设备信息"
        requires :os,      type: String, desc: "设备操作系统版本"
        requires :lang,    type: String, desc: "设备语言code, 例如zh、en"
        requires :country, type: String, desc: "国家code, 例如CN、US"
        requires :version, type: String, desc: "当前app版本"
        requires :udid,    type: String, desc: "设备ID"
        requires :b,       type: String, desc: "Bundle id/Package name"
        requires :p,       type: String, desc: "设备平台, 例如：iOS、Android"
        optional :author,  type: String, desc: "用户"
      end
      post :send do
        @app = App.find_by(app_id: params[:b])
        if @app.blank?
          return { code: -1, message: "App not register in server." }
        end
        
        Feedback.create!(author: params[:author],
                         content: params[:body],
                         model: params[:model],
                         platform: params[:p],
                         os: params[:os],
                         lang: params[:lang],
                         region: params[:country],
                         app_version: params[:version],
                         udid: params[:udid],
                         app_id: @app.id)
                         
        { code: 0, message: "ok" }
        
      end # end send
      
    end # end feedbacks resource
    
  end
end