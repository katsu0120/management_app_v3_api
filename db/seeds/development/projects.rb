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

users.each do |user|
  3.times do |i|

    # company_idに紐づいたprojectsを各ユーザーに作成
    company_first_project = user.projects.create!(company_id: Company.first.id, title: "#{user.name}作成Project#{i + 1}", content: "#{user.name}作成comtent#{i + 1}", updater: "#{user.name}")

    company_second_project = user.projects.create!(company_id: Company.second.id, title: "#{user.name}の会社共有のProject#{i + 1}", content: "#{user.name}のcomtent#{i + 1}")
    # # 最初の2つだけ完了フラグをtrueにする
    company_first_project.update!(completed: true) if i < 2
    company_second_project.update!(completed: true) if i < 2
  end
end

# ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー


puts "projects = #{Project.count}"








