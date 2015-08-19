class Ad < ActiveRecord::Base
  
  validates_presence_of :ad_type, :link, :lang
  
  has_and_belongs_to_many :apps
  accepts_nested_attributes_for :apps, allow_destroy: true, reject_if: :all_blank
  
  has_many :ad_tracks
  
  mount_uploader :landscape_image, LandscapeImageUploader
  mount_uploader :portrait_image,  PortraitImageUploader
  
  AD_TYPES = [['文字', 1], ['图片', 2], ['HTML', 3]]
  AD_LANGS = ['en', 'zh']
  
  def app_names
    apps.map(&:name).join(',')
  end
  
  def buttons
    return button_titles.split(',') if button_titles
    
    []
  end
  
end
