module FeedbacksHelper
  def render_device_info(feedback)
    return "" if feedback.blank?
    
    "【#{feedback.model}】#{feedback.platform} #{feedback.os}"
  end
end