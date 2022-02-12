# Companyを持たないprojectsに紐づくtaskのseedデータ(個人task)
users = User.first(10)
  
users.each do |user|
  5.times do |i|
    # userの個人project1~5に紐づくtasksを作成
    project_first_tasks = user.projects.first.tasks.create!(title:"#{user.name}の個人project1のTask#{i}", content: "test")
    project_second_tasks = user.projects.second.tasks.create!(title:"#{user.name}の個人project2のTask#{i}", content: "test")
    project_third_tasks = user.projects.third.tasks.create!(title:"#{user.name}の個人project3のTask#{i}", content: "test")
    project_fourth_tasks = user.projects.fourth.tasks.create!(title:"#{user.name}の個人project3のTask#{i}", content: "test")
    project_fifth_tasks = user.projects.fifth.tasks.create!(title:"#{user.name}の個人project3のTask#{i}", content: "test")
    
    
    # 最初の2つだけ完了フラグをtrueにする
    project_first_tasks.update!(completed: true)  if i < 2
    project_second_tasks.update!(completed: true) if i < 2
    project_third_tasks.update!(completed: true)  if i < 2
    project_fourth_tasks.update!(completed: true) if i < 2
    project_fifth_tasks.update!(completed: true)  if i < 2
  end
end



# Companyを持つprojectsのTaskのseedデータ(会社共有projectsに紐づくTask)
users.each do |user|
  5.times do |i|
    # userの最初に紐づいている会社共有のproject1~5に紐づくtasksを作成
    shared_project_first_tasks = user.related_companies.first.company.projects.first.tasks.create!(title:"#{user.name}CompanyTaskTitle#{i}", content: "#{user.name}CompanyTaskContent#{i}")
    shared_project_second_tasks = user.related_companies.first.company.projects.second.tasks.create!(title:"#{user.name}CompanyTaskTitle#{i}", content: "#{user.name}CompanyTaskContent#{i}")
    shared_project_third_tasks = user.related_companies.first.company.projects.third.tasks.create!(title:"#{user.name}CompanyTaskTitle#{i}", content: "#{user.name}CompanyTaskContent#{i}")
    shared_project_fourth_tasks = user.related_companies.first.company.projects.fourth.tasks.create!(title:"#{user.name}CompanyTaskTitle#{i}", content: "#{user.name}CompanyTaskContent#{i}")
    shared_project_fifth_tasks = user.related_companies.first.company.projects.fifth.tasks.create!(title:"#{user.name}CompanyTaskTitle#{i}", content: "#{user.name}CompanyTaskContent#{i}")

    # 最初の2つだけ完了フラグをtrueにする
    shared_project_first_tasks.update!(completed: true)  if i < 2
    shared_project_second_tasks.update!(completed: true) if i < 2
    shared_project_third_tasks.update!(completed: true)  if i < 2
    shared_project_fourth_tasks.update!(completed: true) if i < 2
    shared_project_fifth_tasks.update!(completed: true)  if i < 2

  end
end 



puts "Tasks = #{Task.count}"