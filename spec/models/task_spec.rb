require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:project) { FactoryBot.create(:project) }
  
  it "ファクトリでタスクを生成する" do
    task = FactoryBot.create(:task)
  end

  it "タスク作成。親プロジェクトがあれば有効" do
    task = Task.new(
      title: "test",
      content: "test",
      project: project,
    )
    expect(task).to be_valid
  end
  
  it "タスク作成。タイトル、コンテンツが無くても有効" do
    task = Task.new(
      title: nil,
      content: nil,
      project: project,
    )
    expect(task).to be_valid
  end
  

end
