module AppsHelper
  def render_app_icon(app, size = :small)
    return "" if app.blank?
    return "" if app.icon.blank?
    
    image_tag app.icon.url(size)
  end
end