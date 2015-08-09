# t.string :udid
# t.string :app_version
# t.string :device_model
# t.string :os_version
# t.string :language_code
# t.string :country_code
# t.string :from_market
# t.string :screen_size
# t.integer :app_id
# t.string :platform

class AppData < ActiveRecord::Base
  belongs_to :app
  validates :udid, :app_version, :device_model, :os_version, :language_code, :country_code, :screen_size, :app_id, presence: true
  
  def app_info
    "【#{app.name}】#{app_version}"
  end
  
  def device_info
    "【#{device_model}】#{platform} #{os_version}"
  end
end
