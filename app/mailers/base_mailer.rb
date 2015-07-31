class BaseMailer < ActionMailer::Base
  default from: "After Wind <no-reply>@kekestudio.com"
  default charset: "utf-8"
  # default content_type: "text/html"
  default_url_options[:host] = Setting.domain
  
  helper :users
end