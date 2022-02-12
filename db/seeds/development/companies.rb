# Companyの作成。seedデータでは一人1つcompanyを作るようにしてみた。
users = User.first(10)
  
users.each do |user|
  1.times do |i|
    user.companies.create!(name: "Company。userMadeは#{user.name}")

  end
end
# user.firstにだけ、2つcompanyを作成させる
User.first.companies.create!(name: "user0のCompanyTitle2")


# Companyに所属しているUserを作成するseed
companies = Company.first(2)

# Company_id:1,2にuser0~9のユーザーを加える
companies.each do |company|
  10.times do |i|
    company.users.create!(user_id: "#{i + 1}")

  end
end

# user0~2にCompany_id:3,4,5に所属させる
users[0..2].each do |user|
  3.times do |i|
    user.related_companies.create(company_id: "#{i + 3}")

  end
end


puts "companies = #{Company.count}"
puts "companyUser = #{CompanyUser.count}"