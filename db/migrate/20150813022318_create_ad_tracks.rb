class CreateAdTracks < ActiveRecord::Migration
  def change
    create_table :ad_tracks do |t|
      t.string :action        # 追踪行为的名称
      t.string :note          # 追踪行为的结果
      t.string :udid          # 设备id
      t.string :platform      # 平台
      t.string :model         # 设备信息
      t.string :os_version    # 设备操作系统版本
      t.integer :app_id       # 追踪所属的app
      t.integer :ad_id        # 追踪所属的广告
      t.string :app_version   # 当前app的版本号
      t.string :language_code # 语言码
      t.string :country_code  # 国家码

      t.timestamps
    end
    add_index :ad_tracks, :app_id
    add_index :ad_tracks, :ad_id
  end
end
