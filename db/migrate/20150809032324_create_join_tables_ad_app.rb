# 创建 HABTM 关联表命令
# rails g migration CreateJoinTablesAdApp ad app
class CreateJoinTablesAdApp < ActiveRecord::Migration
  def change
    create_join_table :ads, :apps do |t|
      # t.index [:ad_id, :app_id]
      # t.index [:app_id, :ad_id]
    end
  end
end
