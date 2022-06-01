require 'rails_helper'

RSpec.describe "Api::V1::TasksRequests", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:project) { FactoryBot.create(:project) }


  describe "get /api/v1/tasks" do

    context "有効なget /api/v1/tasksリクエスト" do

      it "current_projectの持っているtask一覧を返す" do
    # FactoryBotが複数ユーザーを生成してしまってごっちゃになるから、明示的に分かりやすく2つuserがtask持っているって分かり易いように下記のようにテスト情報生成した
    # ユーザートークンの生成(ログインのショートカット)
        token = user.encode_access_token.token
        headers = { Authorization: "Bearer #{token}" }
        project = FactoryBot.create(:project,
          title: "Sample Project",
          content: "Sample Content",
          creator: user
        )
        task1 = Task.create(
          title:   "RSpecTestTaskTitle1",
          content: "RSpecTestTaskContent1",
          project: project,
        )
        task2 = Task.create(
          title:   "RSpecTestTaskTitle2",
          content: "RSpecTestTaskContent2",
          project: project,
        )
        params = { id: project.id }
      # projects一覧取得リクエスト
        get '/api/v1/tasks', xhr: true,  params: params, headers: headers
        expect(response).to have_http_status "200"
        #  responseで返って来たuserのタスクの数とuser.projects.first.tasksの数がeqになっている場合は正しい
        json2 = JSON.parse(response.body)
        expect(json2.length).to eq(user.projects.first.tasks.length) 

      end
    end



  end

  describe "post /api/v1/tasks" do
    
    context "有効なpost /api/v1/tasksリクエスト" do

      it "current_projectでtaskを問題なく作成" do
        # ユーザートークンの生成(ログインのショートカット)
        token = user.encode_access_token.token
        headers = { Authorization: "Bearer #{token}" }
        project = FactoryBot.create(:project,
          title: "Sample Project",
          content: "Sample Content",
          creator: user
        )
        params = { project: { id: project.id }, task: { title: 'RSpecTaskTitleCreateTest', content: 'RSpecTaskContentCreateTest' } }
      # projects一覧取得リクエスト
        expect {
          post '/api/v1/tasks', xhr: true,  params: params, headers: headers
        }.to change(user.projects.first.tasks, :count).by(1)
        expect(response).to have_http_status "200"
      end


    end
  end

  describe "put /api/v1/tasks" do
    
    context "有効なput /api/v1/tasksリクエスト" do

      it "taskのtitleを問題なく編集できる" do
        # ユーザートークンの生成(ログインのショートカット)
        token = user.encode_access_token.token
        headers = { Authorization: "Bearer #{token}" }
        # projectもここでuser指定して宣言しないとtokenUserとズレる
        project = FactoryBot.create(:project,
          title: "Sample Project",
          content: "Sample Content",
          creator: user
        )
        task = Task.create(
          title:   "RSpecTestTaskTitle1",
          content: "RSpecTestTaskContent1",
          project: project,
        )
        # この状態では上記で作成したタイトルである事が確認。
        expect(project.tasks.first.title).to eq "RSpecTestTaskTitle1"
        content = project.tasks.first.content
        params =  { project: { id: task.project_id }, task: { id: task.id, title: "RSpecTestTaskTitle1の編集テスト", content: content } }
        put '/api/v1/tasks', xhr: true, params: params, headers: headers
        json = JSON.parse(response.body)
        expect(json["title"]).to eq("RSpecTestTaskTitle1の編集テスト")
      end

      it "taskのcontentを問題なく編集できる" do
        # ユーザートークンの生成(ログインのショートカット)
        token = user.encode_access_token.token
        headers = { Authorization: "Bearer #{token}" }
        # projectもここでuser指定して宣言しないとtokenUserとズレる
        project = FactoryBot.create(:project,
          title: "Sample Project",
          content: "Sample Content",
          creator: user
        )
        task = Task.create(
          title:   "RSpecTestTaskTitle1",
          content: "RSpecTestTaskContent1",
          project: project,
        )
        # この状態では上記で作成したタイトルである事が確認。
        expect(project.tasks.first.content).to eq "RSpecTestTaskContent1"
        title = project.tasks.first.title
        params =  { project: { id: task.project_id }, task: { id: task.id, title: title, content: "RSpecTestTaskContent1の編集テスト" } }
        put '/api/v1/tasks', xhr: true, params: params, headers: headers
        json = JSON.parse(response.body)
        expect(json["content"]).to eq("RSpecTestTaskContent1の編集テスト")
      end

      it "taskを問題なく完了に出来る" do

         token = user.encode_access_token.token
         headers = { Authorization: "Bearer #{token}" }
         project = FactoryBot.create(:project,
           title: "Sample Project",
           content: "Sample Content",
           creator: user
         )
         task = Task.create(
           title:   "RSpecTestTaskTitle1",
           content: "RSpecTestTaskContent1",
           project: project,
         )
         #  ここではまだcompleted: falseであることを確認
         expect(task.completed).to be false
         title = project.tasks.first.title
         content = project.tasks.first.content
         params =  { project: { id: task.project_id }, task: { id: task.id, title: title, content: content, completed: true } }
         put '/api/v1/tasks', xhr: true, params: params, headers: headers
         json = JSON.parse(response.body)
         expect(json["completed"]).to be true
         
      end

      it "完了したtaskを問題なく未完了に戻せる" do

         token = user.encode_access_token.token
         headers = { Authorization: "Bearer #{token}" }
         project = FactoryBot.create(:project,
           title: "Sample Project",
           content: "Sample Content",
           creator: user
         )
         task = Task.create(
           title:   "RSpecTestTaskTitle1",
           content: "RSpecTestTaskContent1",
           project: project,
           completed: true
         )
        #  ここではcompleted: trueである事を確認
         expect(task.completed).to be true
         title = project.tasks.first.title
         content = project.tasks.first.content
         params =  { project: { id: task.project_id }, task: { id: task.id, title: title, content: content, completed: false } }
         put '/api/v1/tasks', xhr: true, params: params, headers: headers
         json = JSON.parse(response.body)
         expect(json["completed"]).to be false
      end
      

    end
  end


  describe "delete /api/v1/tasks" do
    
    context "有効なdelete /api/v1/tasksリクエスト" do

      it "taskを問題なく削除できる" do

         token = user.encode_access_token.token
         headers = { Authorization: "Bearer #{token}" }
         project = FactoryBot.create(:project,
           title: "Sample Project",
           content: "Sample Content",
           creator: user
         )
         task = Task.create(
           title:   "RSpecDeleteTestTaskTitle1",
           content: "RSpecDeleteTestTaskContent1",
           project: project,
         )
        # ここではまだtaskを持っている。 
         expect(user.projects.first.tasks.length).to eq(1)

         params =  { project: { id: task.project_id }, task: { id: task.id } }
         delete '/api/v1/tasks', xhr: true, params: params, headers: headers
        # ここでtaskが0になっているので問題なく削除されている事が確認出来る。
         expect(user.projects.first.tasks.length).to eq(0)



      end
    end
  end



end
