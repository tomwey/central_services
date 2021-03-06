# == Schema Information
#
# Table name: site_configs
#
#  id          :integer          not null, primary key
#  key         :string(255)
#  value       :text
#  description :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class SiteConfig < ActiveRecord::Base
  validates :key, :value, :description, presence: true
  validates_uniqueness_of :key
  
  def self.method_missing(method, *args)
    method_name = method.to_s
    super(method, *args)
  rescue NoMethodError
    if method_name =~ /=$/
      var_name = method_name.gsub('=', '')
      value = args.first.to_s
      if item = find_by_key(var_name)
        item.update_attribute(:value, value)
      else
        SiteConfig.create(key: var_name, value: value, description: var_name)
      end # end if 
    else 
      Rails.cache.fetch("site_config:#{method}") do
        if item = find_by_key(method)
          item.value
        else
          nil
        end # end if
      end # end cache
    end # end method_name if
  end
  
  after_save :update_cache
  def update_cache
    Rails.cache.write("site_config:#{self.key}", self.value)
  end
  
  def self.find_by_key(key)
    where(key: key.to_s).first
  end
  
end
