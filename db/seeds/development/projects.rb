# Companyを持たないprojectsのseedデータ(個人projects)
users = User.first(10)
  
users.each do |user|
  5.times do |i|
    project = user.projects.create!(title: "#{user.name}の個人ProjectTitle#{i + 1}", content: "#{user.name}のcomtent#{i + 1}")
    # 最初の2つだけ完了フラグをtrueにする
    project.update!(completed: true) if i < 2
  end
end


# ーーーー下記からは共有のprojectーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー

# Companyを持つprojectsのseedデータ(Company共有projects)

# User.find(1).related_companies.first.company.projects.create!(user_id: 1, title: "別に一緒なのか", content: "test")

users.each do |user|
  5.times do |i|
    # company_id:1と2を取得したいだけ(CompanyUserじゃない場合は弾く為に変数定義)
    company_user_first = Company.first.users.first
    company_user_second = Company.second.users.first

    # company_idに紐づいたprojectsを各ユーザーに作成
    company_first_project = user.projects.create!(company_id: company_user_first.company_id, title: "#{user.name}の会社共有のProject#{i + 1}", content: "#{user.name}のcomtent#{i + 1}")

    company_second_project = user.projects.create!(company_id: company_user_second.company_id, title: "#{user.name}の会社共有のProject#{i + 1}", content: "#{user.name}のcomtent#{i + 1}")
    # 最初の2つだけ完了フラグをtrueにする
    company_first_project.update!(completed: true) if i < 2
    company_second_project.update!(completed: true) if i < 2
  end
end

# ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー


puts "projects = #{Project.count}"