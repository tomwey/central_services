class AddErrorMessageToAdTracks < ActiveRecord::Migration
  def change
    add_column :ad_tracks, :error_message, :string
  end
end
