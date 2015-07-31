# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

SiteConfig.create!(key: 'app_types', value: '应用,游戏', description: 'App类别')
SiteConfig.create!(key: 'manager_emails', value: 'kekestudio@163.com,kekestudio@sina.com', description: '管理员账号')
SiteConfig.create!(key: 'app_platforms', value: 'iOS,Android', description: 'App支持的系统平台')