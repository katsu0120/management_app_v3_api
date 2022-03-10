
users = User.first(10)

# user0~2をカンパニーに参加させる。
users.each do |user|
  3.times do |i|
   user.related_companies.create(company_id: "#{i + 1}")

  end
end


# # user0~2にCompany_id:4,5,6に所属させる
# users[0..2].each do |user|
#   3.times do |i|
#     user.related_companies.create(company_id: "#{i + 4}")

#   end
# end


# puts "companyUser = #{CompanyUser.count}"