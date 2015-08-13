class AdTrack < ActiveRecord::Base
  belongs_to :ad
  belongs_to :app
end
