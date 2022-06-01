require 'rails_helper'

RSpec.describe "Api::V1::CompanyUsersRequests", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:company) { FactoryBot.create(:company) }
 
  describe "get /api/v1/company_users" do

    context "有効なget /api/v1/company_usersリクエスト" do

      it "ログインユーザーの参加カンパニーを取得している" do
        user1   = FactoryBot.create(:user, name: "company_test_user1")
        user2   = FactoryBot.create(:user, name: "company_test_user2")
        user3   = FactoryBot.create(:user, name: "company_test_user3")
        company = FactoryBot.create(:company, owner: user1, name: "参加カンパニーテスト用カンパニー(CompanyUser)")
      # 作成したcompanyに作成ユーザーを参加させるコード
        company.users.create(user_id: user1.id)
        company.users.create(user_id: user2.id)
        company.users.create(user_id: user3.id)
      # ログイン
        token = user1.encode_access_token.token
        headers = { Authorization: "Bearer #{token}" }
        params =  { id: company.id }
        get '/api/v1/company_users', xhr: true, params: params, headers: headers
        json = JSON.parse(response.body)
      # 上記で作成したCompanyで参加させたカンパニーユーザー数とuser1でログインして、
      # 作ったカンパニーにリクエスト送って取得する参加ユーザー数が同じになる
        expect(company.users.count).to eq(json.count)
      end
    end
  end

  describe "post /api/v1/company_users" do

    context "有効なpost /api/v1/company_usersリクエスト" do

      it "問題なく参加ユーザーに追加出来る" do
        user1   = FactoryBot.create(:user, name: "company_post_test_user1")
        user2   = FactoryBot.create(:user, name: "company_post_test_user2")
        user3   = FactoryBot.create(:user, name: "company_post_test_user3")
        company = FactoryBot.create(:company, owner: user1, name: "参加カンパニーテスト用カンパニー(CompanyUser)")
      # 作成したcompanyに作成ユーザーを参加させるコード
        company.users.create!(user_id: user1.id)
      # ここではcompanyの参加ユーザー数は1
        expect(company.users.count).to eq(1)
      # ログイン
        token = user1.encode_access_token.token
        headers = { Authorization: "Bearer #{token}" }
      # 検索  (すでに参加しているユーザーはfront側で弾くのでここでは表示される)
        params = { params: { findName: "factory_test_user"} }
        get '/api/v1/finders', xhr: true, params: params, headers: headers
        json = JSON.parse(response.body)
      # カンパニーにユーザー追加
        params = { company: { id: company.id, name: company.name }, users: { user_id: user2.id } }
        post '/api/v1/company_users', xhr: true, params: params, headers: headers
      # user2をcompanyに参加させたのでユーザー数は2になっている
        expect(company.users.count).to eq(2)
      end

    end

  end

  describe "destroy /api/v1/company_users" do

    context "有効なdestroy /api/v1/company_usersリクエスト" do

      it "参加ユーザーを問題なく不参加に  出来る" do
        user1   = FactoryBot.create(:user, name: "company_delete_test_user1")
        user2   = FactoryBot.create(:user, name: "company_delete_test_user2")
        user3   = FactoryBot.create(:user, name: "company_delete_test_user3")
        company = FactoryBot.create(:company, owner: user1, name: "参加カンパニーテスト用カンパニー(CompanyUser)")
      # 作成したcompanyに作成ユーザーを参加させるコード
        company.users.create(user_id: user1.id)
        company.users.create(user_id: user2.id)
        company.users.create(user_id: user3.id)
      # ここの段階ではcompany_usersが3
        expect(company.users.count).to eq(3)
      # ログイン
        token = user1.encode_access_token.token
        headers = { Authorization: "Bearer #{token}" }
        params = { company: { id: company.id }, users: { user_id: user2.id } }
        delete '/api/v1/company_users', xhr: true, params: params, headers: headers
      # company_usersを一人減らしたので上記リクエストにより2になっている
        expect(company.users.count).to eq(2)





      end

    end

  end








end
