# encoding: utf-8

class PortraitImageUploader < BaseUploader
    
  version :big do
    process resize_to_fill: [594, 960]
    # process resize_to_fill: [750, 1334]
  end
  
  version :large do
    process resize_to_fill: [824, 1334]
    # process resize_to_fill: [900, 1334]
  end

  # version :normal do
  #   process resize_to_fill: [1080, 1920]
  # end

  def filename
    if super.present?
      "#{secure_token}.#{file.extension}"
    end
  end
  
  def extension_white_list
    %w(jpg jpeg png webp)
  end
  
  protected
    def secure_token
      var = :"@#{mounted_as}_secure_token"
      model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
    end

end
