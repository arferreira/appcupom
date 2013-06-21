# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create :name => "Paulo Henrique Pires", :email => "taralloqueiroiz@gmail.com", :gender => "Masculino", :password => "123123123"
User.create :name => "Antonio Ricardo", :email => "antonioricardo@ifollowagencia.com.br", :gender => "Masculino", :password => "123123123"
Administrator.create :name => "Paulo Henrique", :email => "taralloqueiroiz@gmail.com", :admin_role_id => 1, :password => "123123123"
