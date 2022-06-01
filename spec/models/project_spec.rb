require 'rails_helper'

RSpec.describe Project, type: :model do
#########################################################
# company_projectはcompany_idがnilかそうじゃないかの違いの為、このモデルで個人projectとカンパニープロジェクトを作成
##########################################################
  it "ファクトリのprojectのデータ作成のテスト" do
    project = FactoryBot.create(:project)
  end

  it "titleを更新できる" do
    project = FactoryBot.create(:project)
    project.title = "タイトルupdate"
    expect(project).to be_valid
  end

  it "contentを更新できる" do
    project = FactoryBot.create(:project)
    project.content = "コンテンツupdate"
    expect(project).to be_valid
  end

  it "contentを完了できる" do
    project = FactoryBot.create(:project)
    project.content = "コンテンツupdate"
    expect(project).to be_valid
  end

  it "5つのタスクが付いているProject作成テスト" do
    project = FactoryBot.create(:project, :with_tasks)
    expect(project.tasks.length).to eq 5
  end

end
