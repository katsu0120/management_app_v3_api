require 'rails_helper'

RSpec.describe "Api::V1::FindersRequests", type: :request do
  describe "GET /api/v1/finders_requests" do
    
    context "有効な/api/v1/finders_requestsリクエスト" do
      
      it "問題なくuser検索が出来ている" do
        user1 = FactoryBot.create(:user, name: "find_test_user1")
        user2 = FactoryBot.create(:user, name: "find_test_user2")
        user3 = FactoryBot.create(:user, name: "find_test_user3")
        company = FactoryBot.create(:company, owner: user1, name: "finderテスト用カンパニー")
      # 作成したcompanyに作成ユーザーを参加させるコード
        company.users.create(user_id: user1.id)
      # ログイン
        token = user1.encode_access_token.token
        headers = { Authorization: "Bearer #{token}" }
        params = { params: { findName: "find_test_user"} }
        get '/api/v1/finders', xhr: true, params: params, headers: headers
        json = JSON.parse(response.body)
      # 上記で作ったユーザーの名前がfinderの結果として返ってくるのでcount:3となる。        
      # compeny参加ユーザーはfrontで表示しないように弾いているのでここでは3でOK
        expect(json.count).to eq(3)
      end

    end






  end











end
