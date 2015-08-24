# encoding: utf-8

class LandscapeImageUploader < BaseUploader

  # version :thumb do
  #   process resize_to_fill: [568, 320]
  # end
  #
  # version :medium do
  #   process resize_to_fill: [1136, 640]
  # end
  #
  # version :big do
  #   process resize_to_fill: [1334, 750]
  # end
  #
  # version :large do
  #   process resize_to_fill: [1600, 900]
  # end
  #
  # version :normal do
  #   process resize_to_fill: [1920, 1080]
  # end
  
  version :big do
    process resize_to_fill: [960, 594]
    # process resize_to_fill: [750, 1334]
  end
  
  version :large do
    process resize_to_fill: [1334, 824]
    # process resize_to_fill: [900, 1334]
  end

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
