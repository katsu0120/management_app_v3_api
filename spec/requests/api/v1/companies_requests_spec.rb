require 'rails_helper'

RSpec.describe "Api::V1::CompaniesRequests", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:company) { FactoryBot.create(:company) }

  describe "get /api/v1/companies" do

    context "有効なget /api/v1/companyリクエスト" do

      it "ログインユーザーの参加カンパニー一覧を返す" do
        company = FactoryBot.create(:company, owner: user)
      # 作成したcompanyに作成ユーザーを参加させるコード
        company.users.create!(user_id: user.id)

        # # 正常なログイン
        params = { auth: { email: user.email, password: user.password } } 
        login(params)
        expect(response).to have_http_status "200"
        json1 = JSON.parse(response.body)
        token = json1["token"]
        headers = { Authorization: "Bearer #{token}" } 
        # company一覧取得リクエスト
        get '/api/v1/companies', xhr: true, headers: headers
        expect(response).to have_http_status(:success)
        json2 = JSON.parse(response.body)
  #  # 返って来た参加カンパニ一覧とcompany.users.countがイコール  
        expect(json2.count).to eq(company.users.count)
      end
    
    end

  end

  describe "post /api/v1/companies" do

    context "有効なpost /api/v1/companyリクエスト" do

      it "ログインユーザーでカンパニーを作成する" do
       # # ログインtoken作成ショートカット
        token = user.encode_access_token.token
        headers = { Authorization: "Bearer #{token}" }
        params = { company: { name: "RSpecテストカンパニークリエイト" } }
        # company作成リクエスト
        expect {
          post '/api/v1/companies', xhr: true, params: params, headers: headers
        }.to change(user.companies, :count).by(1)
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "put /api/v1/companies" do

    context "有効なput /api/v1/companyリクエスト" do

      it "カンパニー名を編集する" do
       # # ログインtoken作成ショートカット
        token = user.encode_access_token.token

        company = FactoryBot.create(:company, owner: user, name: "FactoryBot_CompanyName2")
      # 作成したcompanyに作成ユーザーを参加させるコード
        company.users.create!(user_id: user.id)
      # まだデフォルトのFactoryBotの名前である事のテスト
        expect(company.name).to eq("FactoryBot_CompanyName2")

        headers = { Authorization: "Bearer #{token}" }
        params = { company: { id: company.id, name: "RSpecテストカンパニー編集test" } }
        put '/api/v1/companies', xhr: true, params: params, headers: headers
        json = JSON.parse(response.body)
        # ちゃんと名前が編集されている事が確認出来る
        expect(json["name"]).to eq "RSpecテストカンパニー編集test"
        expect(response).to have_http_status(:success)
      end
    end
  end
  describe "delete /api/v1/companies" do

    context "有効なdelete /api/v1/companyリクエスト" do

      it "カンパニーを削除する" do
       # # ログインtoken作成ショートカット
        token = user.encode_access_token.token
        company = FactoryBot.create(:company, owner: user, name: "company削除テスト")
      # 作成したcompanyに作成ユーザーを参加させるコード
        company.users.create!(user_id: user.id)
      # 作成したのでuserが持つcompanyの数値が1である事を確認
        expect(user.companies.count).to eq(1)

        headers = { Authorization: "Bearer #{token}" }
        params = { company: { id: company.id } }
        delete '/api/v1/companies', xhr: true, params: params, headers: headers
        json = JSON.parse(response.body)
      # 削除したのでuserが持つcompanyの数値が0である事を確認
        expect(user.companies.count).to eq(0)
        expect(response).to have_http_status(:success)
      end
    end
  end








end
