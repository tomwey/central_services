class Ad < ActiveRecord::Base
  
  validates_presence_of :title, :ad_type, :link, :button_titles, :lang
  
  has_and_belongs_to_many :apps
  accepts_nested_attributes_for :apps, allow_destroy: true, reject_if: :all_blank
  
  AD_TYPES = [['文字', 1], ['图片', 2]]
  AD_LANGS = ['en', 'zh']
  
  def app_names
    apps.map(&:name).join(',')
  end
  
  def buttons
    return button_titles.split(',') if button_titles
    
    []
  end
  
end
