# Companyの作成。seedデータでは一人1つcompanyを作るようにしてみた。
users = User.first(10)
  
users.each do |user|
  1.times do |i|
    company = user.companies.create!(name: "Company#{user.name}")
  end
end
# user0~3にだけ、2つcompanyを作成させる
User.first.companies.create!(name: "user0のCompany2つ目")
User.second.companies.create!(name: "user1のCompany2つ目")
User.third.companies.create!(name: "user2のCompany2つ目")

puts "companies = #{Company.count}"

