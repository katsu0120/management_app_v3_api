require 'rails_helper'

RSpec.describe "Api::V1::ProjectsRequests", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:project) { FactoryBot.create(:project) }


  describe "get /api/v1/projects" do

    context "個人Projectのステータス確認" do

      it "作成されるprojectsのstatusは正しいかテスト" do
        # 個人プロジェクトなのでcompany_idはnilになっている
        expect(project.company_id).to be_nil
        expect(project.completed).to be false
        expect(project.created_at).to_not be_nil
        expect(project.id).to_not be_nil
        expect(project.updated_at).to_not be_nil
        # 更新者も個人プロジェクトではnilになっているのが正しい
        expect(project.updater).to be_nil
        expect(project.user_id).to_not be_nil
      end
    end

    context "有効なget /api/v1/projectsリクエスト" do

      it "ログインユーザーのprojects一覧を返す" do
        project1 = FactoryBot.create(:project,
          title: "Sample Project",
          content: "Sample Content",
          creator: user
        )
        project2 = FactoryBot.create(:project,
          title: "Second Sample Project",
          content: "Second Sample Content",
          creator: user)
      # # 正常なログイン
         params = { auth: { email: user.email, password: user.password } } 
         login(params)
         expect(response).to have_http_status "200"
         json1 = JSON.parse(response.body)
         token = json1["token"]
         headers = { Authorization: "Bearer #{token}" } 
         
      # projects一覧取得リクエスト
         get '/api/v1/projects', xhr: true, headers: headers
         expect(response).to have_http_status(:success)
         json2 = JSON.parse(response.body)
    # 返って来たprojects一覧とuser.projects.countがイコール  
         expect(json2.count).to eq(user.projects.count)
      end
    end

    context "無効なget /api/v1/projectsリクエスト" do

      it "ログインしていないのでprojects一覧を取得できない" do
        token = ""
        headers = { Authorization: "Bearer #{token}" } 
        get '/api/v1/projects', xhr: true, headers: headers
        expect(response).to have_http_status "401"
      end
    end


  end

  describe "post /api/v1/projects" do

    context "有効なpost /api/v1/projectsリクエスト" do

      it "プロジェクト作成が正常に出来る" do
      # # 正常なログイン
        params = { auth: { email: user.email, password: user.password } } 
        login(params)
        expect(response).to have_http_status "200"
        json = JSON.parse(response.body)
        token = json["token"]
      # プロジェクト作成
        headers = { Authorization: "Bearer #{token}" }
        params = { project: { title: "testプロジェクトタイトル", content: "testプロジェクトコンテンツ" } } 
        expect {
          post '/api/v1/projects', xhr: true, params: params, headers: headers
      # プロジェクト作成に成功して問題なく1つプロジェクトが増えている
        }.to change(user.projects, :count).by(1)
        expect(response).to have_http_status(:success)
        
      end
    end

    context "無効な/api/v1/projectsへのリクエスト" do

      it "ログインしていないので、プロジェクトの追加が出来ないこと" do
        # プロジェクト作成
        params = { project: { title: "testプロジェクトタイトル", content: "testプロジェクトコンテンツ" } } 
        expect {
          post '/api/v1/projects', xhr: true, params: params
          # プロジェクト数が変わっていない。
        }.to_not change(user.projects, :count)
      end

      it "ユーザー認証に使っているheaderのtokenが不正なのでプロジェクトの追加が出来ないこと" do
        # プロジェクト作成
        token = "testtesttesttesttesttesttesttesttesttesttesttesttesttest"
        headers = { Authorization: "Bearer #{token}" }
        params = { project: { title: "testプロジェクトタイトル", content: "testプロジェクトコンテンツ" } } 
        expect {
          post '/api/v1/projects', xhr: true, params: params, headers: headers
          # プロジェクトが増えていない
        }.to_not change(user.projects, :count)
      end
    end

  end

  describe "put /api/v1/projects" do

    context "有効なput /api/v1/projectsリクエスト" do

      it "プロジェクトtitleの編集テスト" do
        project1 = FactoryBot.create(:project,
          title: "Sample Project",
          content: "Sample Content",
          creator: user
        )
    # # ログインtoken作成ショートカット
        token = user.encode_access_token.token
        headers = { Authorization: "Bearer #{token}" }

      # userのproject.first.titleは上記で作ったtitleと相違無いこと確認
        expect(user.projects.first.title).to eq("Sample Project")
        params ={ project: { id: user.projects.first.id, title: "updateプロジェクトタイトル", content: user.projects.first.content } }
        put '/api/v1/projects', xhr: true, params: params, headers: headers
        json = JSON.parse(response.body)
      # titleがupdateされている事確認
        expect(json["title"]).to eq("updateプロジェクトタイトル")
     
      end

      it "プロジェクトcontent編集のテスト" do
        project1 = FactoryBot.create(:project,
          title: "Sample Project",
          content: "Sample Content",
          creator: user
        )
    # # ログインtoken作成ショートカット
        token = user.encode_access_token.token
        headers = { Authorization: "Bearer #{token}" }
    # userのproject.first.titleは上記で作ったtitleと相違無いこと確認
        expect(user.projects.first.content).to eq("Sample Content")
      # contentのupdate
        params ={ project: { id: user.projects.first.id, title: user.projects.first.title, content: "updateのプロジェクトコンテンツ" } }
        put '/api/v1/projects', xhr: true, params: params, headers: headers
        json = JSON.parse(response.body)
        expect(json["content"]).to eq("updateのプロジェクトコンテンツ")


      end


      it "プロジェクトの完了と未完了に戻す編集テスト" do
        project1 = FactoryBot.create(:project,
          title: "Sample Project",
          content: "Sample Content",
          creator: user
        )
      # userのproject.firstはまだcompleted: falseである事がテスト
        expect(user.projects.first.completed).to eq false

      # # ログインtoken作成ショートカット
        token = user.encode_access_token.token
        headers = { Authorization: "Bearer #{token}" }

      # プロジェクトを完了するリクエスト
        params = { project: { id: user.projects.first.id, title: user.projects.first.title, content: user.projects.first.content, completed: true } }
        put '/api/v1/projects', xhr: true, params: params, headers: headers
        json = JSON.parse(response.body)
        expect(json["completed"]).to eq true
        
      # プロジェクトを未完了に戻すリクエスト
        params = { project: { id: user.projects.first.id, title: user.projects.first.title, content: user.projects.first.content, completed: false } }
        put '/api/v1/projects', xhr: true, params: params, headers: headers
        json = JSON.parse(response.body)
        expect(json["completed"]).to eq false
        

      end

    end
  end


  describe "delete /api/v1/projects" do

    context "有効なdelete /api/v1/projectsリクエスト" do

      it "プロジェクトを削除するテスト" do
        project1 = FactoryBot.create(:project,
          title: "Sample Project",
          content: "Sample Content",
          creator: user
        )
         # # ログインtoken作成ショートカット
         token = user.encode_access_token.token
         headers = { Authorization: "Bearer #{token}" }
        
       # ユーザーがこの時は一つprojectを持っていることを確認
         expect(user.projects.count).to eq(1)
 
       # プロジェクトを削除するリクエスト
         params = { project: { id: user.projects.first.id } }
         delete '/api/v1/projects', xhr: true, params: params, headers: headers
      #  削除したのでuser.projects.countは0になった
         expect(user.projects.count).to eq(0)

      end

    end

  end

  
end
