# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'faker'


15.times do
  User.create!(
    email: Faker::Internet.email,
    password: Faker::Internet.password(8,16)
  )
end

50.times do
  Wiki.create!(
    title: Faker::Lorem.word,
    body: Faker::Lorem.paragraph,
    user_id: Faker::Number.between(1,15)
  )
end

wikis = Wiki.all
users = User.all


puts "Seed finished"
puts "#{Wiki.count} wikis created"
puts "#{User.count} users created"
