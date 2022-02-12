# Companyを持たないprojectsのseedデータ(個人projects)
users = User.first(10)
  
users.each do |user|
  5.times do |i|
    project = user.projects.create!(title: "#{user.name}の個人ProjectTitle#{i + 1}", content: "#{user.name}のcomtent#{i + 1}")
    # 最初の2つだけ完了フラグをtrueにする
    project.update!(completed: true) if i < 2
  end
end

# Companyを持つprojectsのseedデータ(Company共有projects)
users.each do |user|
  5.times do |i|
    # company_id:1と2を取得したいだけ(CompanyUserじゃない場合は弾く為に変数定義)
    company_user_first = Company.find(1).users.first
    company_user_second = Company.find(2).users.first

    # company_idに紐づいたprojectsを各ユーザーに作成
    company_first_project = user.projects.create!(company_id: company_user_first.company_id, title: "#{user.name}の会社共有Company1のProjectTitle#{i + 1}", content: "#{user.name}のcomtent#{i + 1}")

    company_second_project = user.projects.create!(company_id: company_user_second.company_id, title: "#{user.name}の会社共有Company2のProjectTitle#{i + 1}", content: "#{user.name}のcomtent#{i + 1}")
    # 最初の2つだけ完了フラグをtrueにする
    company_first_project.update!(completed: true) if i < 2
    company_second_project.update!(completed: true) if i < 2
  end
end


puts "projects = #{Project.count}"