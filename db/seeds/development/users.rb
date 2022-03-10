10.times do |n|
  name = "user#{n}"
  email = "#{name}@example.com"
  user = User.find_or_initialize_by(email: email, activated: true)
  user_profile = "テストユーザー#{n}のプロフィールです。"

  if user.new_record?
    user.name = name
    user.password = "password"
    user.user_profile = user_profile
    user.save!
  end
end

puts "users = #{User.count}"