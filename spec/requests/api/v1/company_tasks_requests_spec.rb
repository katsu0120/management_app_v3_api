require 'rails_helper'

RSpec.describe "Api::V1::CompanyTasksRequests", type: :request do
  
  describe "GET /api/v1/company_tasks_requests" do
    
    context "有効なGET /api/v1/company_tasks_requests" do
    
      it "カレントプロジェクトのタスク一覧が取得できている" do
        user1 = FactoryBot.create(:user, name: "company_tasks_test_user1")
        company = FactoryBot.create(:company, owner: user1)
        # Taskを5つ持ったprojetを作成
        company_project = FactoryBot.create(:project, :with_tasks, user_id: user1.id, company_id: company.id, title: "company_tasks_test_titile1", content: "company_tasks_test_content1")
        # 作成したcompanyに作成ユーザーを参加させるコード
        company.users.create!(user_id: user1.id)
        # ログイン
        token = user1.encode_access_token.token
        headers = { Authorization: "Bearer #{token}" }
        params = { id: company.id, projectId: company_project.id } 
        # リクエスト
        get '/api/v1/company_tasks', xhr: true, params: params, headers: headers
        json = JSON.parse(response.body)
        expect(json.count).to eq(company_project.tasks.count)
      end

      it "他の参加ユーザーもカレントプロジェクトのタスク一覧が取得できている" do
        user1 = FactoryBot.create(:user, name: "company_tasks_test_user1")
        user2 = FactoryBot.create(:user, name: "company_tasks_test_user2")
        # user1でプロジェクト関係を作成
        company = FactoryBot.create(:company, owner: user1)
        company_project = FactoryBot.create(:project, :with_tasks, user_id: user1.id, company_id: company.id, title: "company_tasks_test_titile1", content: "company_tasks_test_content1")
        # 作成したcompanyに作成ユーザーを参加させるコード
        company.users.create!(user_id: user1.id)
        company.users.create!(user_id: user2.id)
        # user2でログイン
        token = user2.encode_access_token.token
        headers = { Authorization: "Bearer #{token}" }
        params = { id: company.id, projectId: company_project.id } 
        # リクエスト
        get '/api/v1/company_tasks', xhr: true, params: params, headers: headers
        json = JSON.parse(response.body)
        expect(json.count).to eq(company_project.tasks.count)
      end

    end
  end

  describe "post /api/v1/company_tasks_requests" do
    
    context "有効なpost /api/v1/company_tasks_requests" do
    
      it "問題なくtaskの作成が出来る。" do
        user1 = FactoryBot.create(:user, name: "company_tasks_test_user1")
        company = FactoryBot.create(:company, owner: user1)
        # Taskを5つ持ったprojetを作成
        company_project = FactoryBot.create(:project, :with_tasks, user_id: user1.id, company_id: company.id, title: "company_tasks_test_titile1", content: "company_tasks_test_content1")
        # 作成したcompanyに作成ユーザーを参加させるコード
        company.users.create!(user_id: user1.id)
        # ここではまだcompany_projectが持っているtask数は5
        expect(company_project.tasks.count).to eq(5)
        # ログイン
        token = user1.encode_access_token.token
        headers = { Authorization: "Bearer #{token}" }
        params = { company: { id: company.id }, project: { id: company_project.id }, task: { title: 'newTaskCreateTitile', content: 'newTaskCreateContent', updater: user1.name } }
        # リクエスト
        expect {
        post '/api/v1/company_tasks', xhr: true, params: params, headers: headers
        }.to change(company_project.tasks, :count).by(1)
        # 上記リクエストによってtasksが1つ増えている事が確認できた
      end

      it "project作成userじゃなくても参加userなら問題なくtaskの作成が出来る。" do
        user1 = FactoryBot.create(:user, name: "company_tasks_test_user1")
        user2 = FactoryBot.create(:user, name: "company_tasks_test_user2")
        # user1がCompanyとpoejectを作成
        company = FactoryBot.create(:company, owner: user1)
        company_project = FactoryBot.create(:project, :with_tasks, user_id: user1.id, company_id: company.id, title: "company_tasks_test_titile1", content: "company_tasks_test_content1")
        # 作成したcompanyに作成ユーザーを参加させるコード
        company.users.create!(user_id: user1.id)
        company.users.create!(user_id: user2.id)
        # ここではまだcompany_projectが持っているtask数は5
        expect(company_project.tasks.count).to eq(5)
        # user2でログイン
        token = user2.encode_access_token.token
        headers = { Authorization: "Bearer #{token}" }
        params = { company: { id: company.id }, project: { id: company_project.id }, task: { title: 'user2NewTaskCreateTitile', content: 'user2NewTaskCreateContent', updater: user2.name } }
        # リクエスト
        expect {
        post '/api/v1/company_tasks', xhr: true, params: params, headers: headers
        }.to change(company_project.tasks, :count).by(1)
        # 上記リクエストによってtasksが1つ増えている事が確認できた
      end

    end
  end

  describe "put /api/v1/company_tasks_requests" do
    
    context "有効なput /api/v1/company_tasks_requests" do
    
      it "問題なくtaskの編集が出来る。" do
        user1           = FactoryBot.create(:user, name: "company_tasks_test_user1")
        company         = FactoryBot.create(:company, owner: user1)
        company_project = FactoryBot.create(:project, user_id: user1.id, company_id: company.id, title: "company_tasks_test_titile1", content: "company_tasks_test_content1")
        # taskの変化が分かり易いように明示的に普通に編集用のcompany_task作成
        company_tasks   = FactoryBot.create(:task, project_id: company_project.id, title: "テストtitle", content: "テストcontent" )
        company.users.create!(user_id: user1.id)
        # ログイン
        token = user1.encode_access_token.token
        headers = { Authorization: "Bearer #{token}" }
        params = { company: { id: company.id }, project: { id: company_project.id }, task: { id: company_tasks.id, title: '編集したタスクのタイトル', content: '編集したタスクのコンテンツ', updater: user1.name } }
        # リクエスト
        put '/api/v1/company_tasks', xhr: true, params: params, headers: headers
        json = JSON.parse(response.body)
        # taskのidが同じなので上記で作成したtaskで間違いない事を確認
        expect(json["id"]).to eq(company_tasks.id )
        # ちゃんと編集されている事を確認
        expect(json["title"]).to eq("編集したタスクのタイトル")
        expect(json["content"]).to eq("編集したタスクのコンテンツ")
      end

      it "参加ユーザーなら作成ユーザーじゃなくても問題なくtaskの編集が出来る。" do
        user1           = FactoryBot.create(:user, name: "company_tasks_test_user1")
        user2           = FactoryBot.create(:user, name: "company_tasks_test_user2")
        company         = FactoryBot.create(:company, owner: user1)
        company_project = FactoryBot.create(:project, user_id: user1.id, company_id: company.id, title: "company_tasks_test_titile1", content: "company_tasks_test_content1")
        company_tasks   = FactoryBot.create(:task, project_id: company_project.id, title: "テストtitle", content: "テストcontent" )
        company.users.create!(user_id: user1.id)
        company.users.create!(user_id: user2.id)
        # ログイン
        token   = user1.encode_access_token.token
        headers = { Authorization: "Bearer #{token}" }
        params  = { company: { id: company.id }, project: { id: company_project.id }, task: { id: company_tasks.id, title: 'user2が編集したタスクのタイトル', content: 'user2が編集したタスクのコンテンツ', updater: user2.name } }
        # リクエスト
        put '/api/v1/company_tasks', xhr: true, params: params, headers: headers
        json = JSON.parse(response.body)
        # taskのidが同じなので上記で作成したtaskで間違いない事を確認
        expect(json["id"]).to eq(company_tasks.id )
        # ちゃんと編集されている事を確認
        expect(json["title"]).to eq("user2が編集したタスクのタイトル")
        expect(json["content"]).to eq("user2が編集したタスクのコンテンツ")
      end

      it "問題なくtaskの完了、未完了が編集出来る。" do
        user1           = FactoryBot.create(:user, name: "company_tasks_test_user1")
        company         = FactoryBot.create(:company, owner: user1)
        company_project = FactoryBot.create(:project, user_id: user1.id, company_id: company.id, title: "company_tasks_test_titile1", content: "company_tasks_test_content1")
        # taskの変化が分かり易いように明示的に普通に編集用のcompany_task作成
        company_tasks   = FactoryBot.create(:task, project_id: company_project.id, title: "テストtitle", content: "テストcontent" )
        company.users.create!(user_id: user1.id)
        # ログイン
        token = user1.encode_access_token.token
        headers = { Authorization: "Bearer #{token}" }
        params = { company: { id: company.id }, project: { id: company_project.id }, task: { id: company_tasks.id, title: company_tasks.title, content: company_tasks.content, updater: user1.name, completed: true } }
        # リクエスト
        put '/api/v1/company_tasks', xhr: true, params: params, headers: headers
        json = JSON.parse(response.body)
        # taskのidが同じなので上記で作成したtaskで間違いない事を確認
        expect(json["id"]).to eq(company_tasks.id )
        # ちゃんと完了になっている事を確認。
        expect(json["completed"]).to be true
        params = { company: { id: company.id }, project: { id: company_project.id }, task: { id: company_tasks.id, title: company_tasks.title, content: company_tasks.content, updater: user1.name, completed: false } }
        # リクエスト
        put '/api/v1/company_tasks', xhr: true, params: params, headers: headers
        json = JSON.parse(response.body)
        # ちゃんと未完了に戻っていることを確認
        expect(json["completed"]).to be false
      end

      it "作成userじゃなくても参加userなら問題なくtaskの完了、未完了が編集出来る。" do
        user1           = FactoryBot.create(:user, name: "company_tasks_test_user1")
        user2           = FactoryBot.create(:user, name: "company_tasks_test_user2")
        company         = FactoryBot.create(:company, owner: user1)
        company_project = FactoryBot.create(:project, user_id: user1.id, company_id: company.id, title: "company_tasks_test_titile1", content: "company_tasks_test_content1")
        # taskの変化が分かり易いように明示的に普通に編集用のcompany_task作成
        company_tasks   = FactoryBot.create(:task, project_id: company_project.id, title: "テストtitle", content: "テストcontent" )
        company.users.create!(user_id: user1.id)
        company.users.create!(user_id: user2.id)
        # user2でログイン
        token = user2.encode_access_token.token
        headers = { Authorization: "Bearer #{token}" }
        params = { company: { id: company.id }, project: { id: company_project.id }, task: { id: company_tasks.id, title: company_tasks.title, content: company_tasks.content, updater: user1.name, completed: true } }
        # リクエスト
        put '/api/v1/company_tasks', xhr: true, params: params, headers: headers
        json = JSON.parse(response.body)
        # taskのidが同じなので上記で作成したtaskで間違いない事を確認
        expect(json["id"]).to eq(company_tasks.id )
        # ちゃんと完了になっている事を確認。
        expect(json["completed"]).to be true
        params = { company: { id: company.id }, project: { id: company_project.id }, task: { id: company_tasks.id, title: company_tasks.title, content: company_tasks.content, updater: user2.name, completed: false } }
        # リクエスト
        put '/api/v1/company_tasks', xhr: true, params: params, headers: headers
        json = JSON.parse(response.body)
        # ちゃんと未完了に戻っていることを確認
        expect(json["completed"]).to be false
      end

    end
  end


  describe "delete /api/v1/company_tasks_requests" do
    
    context "有効なdelete /api/v1/company_tasks_requests" do
    
      it "問題なくtaskの削除が出来る。" do
        user1           = FactoryBot.create(:user, name: "company_tasks_test_user1")
        company         = FactoryBot.create(:company, owner: user1)
        company_project = FactoryBot.create(:project, user_id: user1.id, company_id: company.id, title: "company_tasks_test_titile1", content: "company_tasks_test_content1")
        # taskの変化が分かり易いように明示的に普通に編集用のcompany_task作成
        company_tasks   = FactoryBot.create(:task, project_id: company_project.id, title: "テストtitle", content: "テストcontent" )
        company.users.create!(user_id: user1.id)
        # ログイン
        token = user1.encode_access_token.token
        headers = { Authorization: "Bearer #{token}" }
        params = { company: { id: company.id }, project: { id: company_project.id }, task: { id: company_tasks.id, title: company_tasks.title, content: company_tasks.content, updater: user1.name } }
        # # リクエスト
        expect {
      # 下記リクエストによってtasksが1つ減っている事が確認できる。
        delete '/api/v1/company_tasks', xhr: true, params: params, headers: headers
        }.to change(company_project.tasks, :count).by(-1)
      end
    end
  end







end
