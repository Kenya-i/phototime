# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


User.create!(name: "Example User",
             username: "Example",
             email: "example@user.com",
             password: "foobar",
             password_confirmation: "foobar",
             image: open("#{Rails.root}/public/ハワイ.jpg")
             )



99.times do |n|
    name = Faker::Name.name
    password = "password"
    User.create!(name: name,
                 username: "username" + "#{n}",
                 email: "user" + "#{n}" + "@email.com",
                 password: password,
                 password_confirmation: password,
                 image: open("#{Rails.root}/public/ハワイ.jpg"))
end


# 以下のリレーションシップを作成する
users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }