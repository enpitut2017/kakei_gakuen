# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#Manager.create(name: "enpit", password: "enpit2017", password_confirmation:"enpit2017")
#AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?


User.create(id: 1, name:"akasaka", email:"akasakatora1208@gmail.com", password:"1208tora", password_confirmation:"1208tora", coin:1000, budget:10000);
Clothe.create(id: 1, file_name: "test_name", name: "test", price: 100, image: "test.png", priority: 2);

Tag.create(id: 1, tag: 'upper_clothes');
Tag.create(id: 2, tag: 'lower_clothes');
Tag.create(id: 3, tag: 'sox');
Tag.create(id: 4, tag: 'front_hair');
Tag.create(id: 5, tag: 'back_hair');
Tag.create(id: 6, tag: 'face');

UserWearing.create(id: 1, user_id: 1, upper_clothes: 15, lower_clothes: 2, sox: 3, front_hair: 4, back_hair: 5, face: 12);
ClothesTagsLink.create(id: 1, tag_id: 1, clothes_id: 1);
