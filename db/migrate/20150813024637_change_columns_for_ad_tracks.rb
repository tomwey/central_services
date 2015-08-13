class ChangeColumnsForAdTracks < ActiveRecord::Migration
  def change
    remove_column :ad_tracks, :action
    remove_column :ad_tracks, :note
    add_column    :ad_tracks, :impression, :string
    add_column    :ad_tracks, :click, :string
  end
end
