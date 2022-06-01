require 'rails_helper'

RSpec.describe "Api::V1::CompanyProjectsRequests", type: :request do
  let(:user)    { FactoryBot.create(:user) }

  describe "GET /api/v1/company_projects_requests" do


    context "有効なGET /api/v1/company_projects_requests" do

      it "カンパニープロジェクトが参照できる" do
      # userがカンパニーと、そのプロジェクトを作成
        company         = FactoryBot.create(:company, owner: user)
        company_project = FactoryBot.create(:project, user_id: user.id, company_id: company.id, title: "get_company_projects_test_titile1", content: "get_company_projects_test_content1")
        company_project2 = FactoryBot.create(:project, user_id: user.id, company_id: company.id, title: "get_company_projects_test_titile2", content: "get_company_projects_test_content2")
    
        # 作成したcompanyに作成ユーザーを参加させるコード
        company.users.create!(user_id: user.id)
        # ログイン
        token = user.encode_access_token.token
        headers = { Authorization: "Bearer #{token}" }
        params = { id: company.id }
        get '/api/v1/company_projects', xhr: true, params: params, headers: headers
        json = JSON.parse(response.body)
        expect(response).to have_http_status(:success)
        expect(json.count).to eq(company.projects.count)
      end


      it "参加しているユーザー(company_users)なら誰でもカンパニープロジェクトを参照出来る" do
        user1 = FactoryBot.create(:user, name: "company_project_test_user1")
        user2 = FactoryBot.create(:user, name: "company_project_test_user2")
      # user1がカンパニーと、そのプロジェクトを作成
        company         = FactoryBot.create(:company, owner: user1)
        company_project = FactoryBot.create(:project, user_id: user1.id, company_id: company.id, title: "get_company_projects_test_titile1", content: "get_company_projects_test_content1")
        company_project2 = FactoryBot.create(:project, user_id: user1.id, company_id: company.id, title: "get_company_projects_test_titile2", content: "get_company_projects_test_content2")
      # companyにユーザー1と2を参加させる
        company.users.create!(user_id: user1.id)
        company.users.create!(user_id: user2.id)
        # User2でログイン
        token = user2.encode_access_token.token
        headers = { Authorization: "Bearer #{token}" }
        params = { id: company.id }
        # リクエスト
        get '/api/v1/company_projects', xhr: true, params: params, headers: headers
        json = JSON.parse(response.body)
        # selectは該当するものを全て取得するメソッド。
        # 上記で作ったcompany_projectのcompany_idと同じ物をresponseから取得する
        select = json.select {|a| a["company_id"] == company_project.company_id}
        # company_project.company_idのprojectしかないので変数selectはjson(レスポンス)と全く同じとなるのが分かるので、これでuser1が作ったprojectもuser2が見れていることの確認が出来た
        expect(json).to eq(select)
      end
    end

    context "無効なGET /api/v1/company_projects_requests" do

      it "参加ユーザーではないのでcompanyのprojectを参照出来ない" do
        user1 = FactoryBot.create(:user, name: "company_project_test_user1")
        user2 = FactoryBot.create(:user, name: "company_project_test_user2")
      # user1がカンパニーと、そのプロジェクトを作成
        company         = FactoryBot.create(:company, owner: user1)
        company_project = FactoryBot.create(:project, user_id: user1.id, company_id: company.id, title: "get_company_projects_test_titile1", content: "get_company_projects_test_content1")
        company_project2 = FactoryBot.create(:project, user_id: user1.id, company_id: company.id, title: "get_company_projects_test_titile2", content: "get_company_projects_test_content2")
      # companyにuser2は参加させない
        company.users.create!(user_id: user1.id)
        # User2でログイン
        token = user2.encode_access_token.token
        headers = { Authorization: "Bearer #{token}" }
        params = { id: company.id }
        # リクエスト
        get '/api/v1/company_projects', xhr: true, params: params, headers: headers
        json = JSON.parse(response.body)
        # user2はcompanyに参加してるユーザーじゃないのでリクエストしてもnilが返ってくる。
        expect(json).to eq nil
      end
    end


  end

  describe "post /api/v1/company_projects_requests" do

    context "有効なpost /api/v1/company_projects_requests" do

      it "カンパニープロジェクトを作成出来る" do
        user1 = FactoryBot.create(:user, name: "company_project_test_user1")
      # カンパニーの作成
        company = FactoryBot.create(:company, owner: user1)
      # 作成したcompanyに作成ユーザーを参加させるコード
        company.users.create!(user_id: user1.id)
      # ログイン
        token = user1.encode_access_token.token
        headers = { Authorization: "Bearer #{token}" }
        params = { project: { title: 'カンパニープロジェクト作成テストtitle', content: 'カンパニープロジェクト作成テストcontent', user_id: user1.id, updater: user1.name }, company: { id: company.id } }
        expect {
        post '/api/v1/company_projects', xhr: true, params: params, headers: headers
        }.to change(company.projects, :count).by(1)
      end

      it "カンパニーを作成していないユーザーでも、そのカンパニーのプロジェクトを作成できる" do
        user1 = FactoryBot.create(:user, name: "company_project_test_user1")
        user2 = FactoryBot.create(:user, name: "company_project_test_user2")
      # user1がカンパニーの作成
        company = FactoryBot.create(:company, owner: user1)
      # 作成したcompanyにuser1,user2を参加させる
        company.users.create!(user_id: user1.id)
        company.users.create!(user_id: user2.id)
      # user2でログイン
        token = user2.encode_access_token.token
        headers = { Authorization: "Bearer #{token}" }
        params = { project: { title: 'カンパニープロジェクト他ユーザー作成テストtitle', content: 'カンパニープロジェクト他ユーザー作成テストcontent', user_id: user2.id, updater: user2.name }, company: { id: company.id } }
        post '/api/v1/company_projects', xhr: true, params: params, headers: headers
        json = JSON.parse(response.body)
        expect {
        post '/api/v1/company_projects', xhr: true, params: params, headers: headers
        }.to change(company.projects, :count).by(1)
        
      end

    end

  end



  describe "put /api/v1/company_projects_requests" do

    context "有効なput /api/v1/company_projects_requests" do

      it "カンパニープロジェクトを編集できる" do
        user1 = FactoryBot.create(:user, name: "company_project_test_user1")
        company = FactoryBot.create(:company, owner: user1)
        company.users.create!(user_id: user1.id)
        company_project = FactoryBot.create(:project, user_id: user1.id, company_id: company.id, title: "put_company_projects_test_titile1", content: "put_company_projects_test_content1")
      # ログイン
        token = user1.encode_access_token.token
        headers = { Authorization: "Bearer #{token}" }
        params = { project: { id: company_project.id, title: "カンパニープロジェクト編集テストタイトル", content: "カンパニープロジェクト編集テストコンテンツ", updater: user1.name }, company: { id: company.id } }
        put '/api/v1/company_projects', xhr: true, params: params, headers: headers
        json = JSON.parse(response.body)
        expect(json["title"]).to eq("カンパニープロジェクト編集テストタイトル")
        expect(json["content"]).to eq("カンパニープロジェクト編集テストコンテンツ")
      end

      it "カンパニープロジェクトを別の参加ユーザーでも編集できる" do
        user1 = FactoryBot.create(:user, name: "company_project_test_user1")
        user2 = FactoryBot.create(:user, name: "company_project_test_user2")
      # user1がカンパニーの作成
        company = FactoryBot.create(:company, owner: user1)
      # 作成したcompanyにuser1,user2を参加させる
        company.users.create!(user_id: user1.id)
        company.users.create!(user_id: user2.id)
      # user1がproject作成
        company_project = FactoryBot.create(:project, user_id: user1.id, company_id: company.id, title: "put_company_projects_test_titile1", content: "put_company_projects_test_content1")
      # user2でログイン
        token = user2.encode_access_token.token
        headers = { Authorization: "Bearer #{token}" }
        params = { project: { id: company_project.id, title: "カンパニープロジェクト編集テストタイトル", content: "カンパニープロジェクト編集テストコンテンツ", updater: user2.name }, company: { id: company.id } }
        put '/api/v1/company_projects', xhr: true, params: params, headers: headers
        json = JSON.parse(response.body)
        expect(json["title"]).to eq("カンパニープロジェクト編集テストタイトル")
        expect(json["content"]).to eq("カンパニープロジェクト編集テストコンテンツ")
        expect(json["updater"]).to eq(user2.name)
      end

      it "カンパニープロジェクトを問題なく完了に出来る" do
        user1 = FactoryBot.create(:user, name: "company_project_test_user1")
        company = FactoryBot.create(:company, owner: user1)
        company.users.create!(user_id: user1.id)
        company_project = FactoryBot.create(:project, user_id: user1.id, company_id: company.id, title: "put_company_projects_test_titile1", content: "put_company_projects_test_content1")
      # ログイン
        token = user1.encode_access_token.token
        headers = { Authorization: "Bearer #{token}" }
      # 完了リクエスト
        params = { project: { id: company_project.id, title: company_project.title, content: company_project.content, updater: user1.name, completed: true }, company: { id: company.id } }
        put '/api/v1/company_projects', xhr: true, params: params, headers: headers
        json = JSON.parse(response.body)
        expect(json["completed"]).to eq true
      end

      it "カンパニープロジェクトを問題なく未完了に出来る" do
        user1 = FactoryBot.create(:user, name: "company_project_test_user1")
        company = FactoryBot.create(:company, owner: user1)
        company.users.create!(user_id: user1.id)
        company_project = FactoryBot.create(:project, user_id: user1.id, company_id: company.id, title: "put_company_projects_test_titile1", content: "put_company_projects_test_content1")
      # ログイン
        token = user1.encode_access_token.token
        headers = { Authorization: "Bearer #{token}" }
        # 未完了リクエスト
        params = { project: { id: company_project.id, title: company_project.title, content: company_project.content, updater: user1.name, completed: false }, company: { id: company.id } }
        put '/api/v1/company_projects', xhr: true, params: params, headers: headers
        json = JSON.parse(response.body)
        expect(json["completed"]).to eq false
      end
      

    end

  end

  describe "delete /api/v1/company_projects_requests" do

    context "有効なdelete /api/v1/company_projects_requests" do

      it "カンパニープロジェクトを削除できる" do
        user1   = FactoryBot.create(:user, name: "company_project_test_user1")
        company = FactoryBot.create(:company, owner: user1)
        company.users.create!(user_id: user1.id)
        company_project = FactoryBot.create(:project, user_id: user1.id, company_id: company.id, title: "delete_company_projects_test_titile1", content: "delete_company_projects_test_content1")
      # ここではcompany.projectsは1
        expect(company.projects.count).to eq(1)
      # ログイン
        token = user1.encode_access_token.token
        headers = { Authorization: "Bearer #{token}" }
        params = { project: { id: company_project.id, title: company_project.title, content: company_project.content }, company: { id: company.id } }
        delete '/api/v1/company_projects', xhr: true, params: params, headers: headers
        # ここではprojectを削除したのでcompany.projectsは0になっている
        expect(company.projects.count).to eq(0)


      end
    end
  end









end
