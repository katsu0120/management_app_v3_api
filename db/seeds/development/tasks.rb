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


# ーーーーー共有projectsーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー

  5.times do |i|
    # company.firstのtasks
    company_first_project_first_tasks = Company.first.projects.first.tasks.create!(title: "テストTitle#{i}", content: "テストContent#{i}", updater: Company.first.owner.name)
    company_first_project_second_tasks = Company.first.projects.second.tasks.create!(title: "テストTitle#{i}", content: "テストContent#{i}", updater: Company.first.owner.name)
    company_first_project_third_tasks = Company.first.projects.third.tasks.create!(title: "テストTitle#{i}", content: "テストContent#{i}", updater: Company.first.owner.name)
    company_first_project_first_tasks.update!(completed: true)  if i < 2
    company_first_project_second_tasks.update!(completed: true)  if i < 2
    company_first_project_third_tasks.update!(completed: true)  if i < 2

    # company.secondのtasks
    company_second_project_first_tasks = Company.second.projects.first.tasks.create!(title: "テストTitle#{i}", content: "テストContent#{i}", updater: Company.second.owner.name)
    company_second_project_second_tasks = Company.second.projects.second.tasks.create!(title: "テストTitle#{i}", content: "テストContent#{i}", updater: Company.second.owner.name)
    company_second_project_third_tasks = Company.second.projects.third.tasks.create!(title: "テストTitle#{i}", content: "テストContent#{i}", updater: Company.second.owner.name)
    company_second_project_first_tasks.update!(completed: true)  if i < 2
    company_second_project_second_tasks.update!(completed: true)  if i < 2
    company_second_project_third_tasks.update!(completed: true)  if i < 2

  end



puts "Tasks = #{Task.count}"
