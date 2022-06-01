require 'rails_helper'

RSpec.describe "Api::V1::UsersRequests", type: :request do
  
  describe "ログイン関係のテスト" do
    let(:user) { FactoryBot.create(:user) }

    it "新規作成時問題なく認証メールが送られているかテスト" do
      new_user = User.new(
        name: "test",
        email: "test@example.com",
        password: "password"
      )
      params = { user: { email: new_user.email, password: new_user.password } } 
      post '/api/v1/users', xhr: true, params: params
      expect(response).to have_http_status "200"
      json = JSON.parse(response.body)
      # mail送信テストは別途mailerでテスト
      # 下記jsonが返されていれば問題なくemailが送られている。
      expect(json).to eq("color"=>"#0091EA", "msg"=>"ご登録のメールアドレスに認証メールをご送付させていただきました")
    end

    it "同じemailアドレスで登録しようとした場合、エラーjsonレスポンスを返す" do
      new_user = User.new(
        name: "emailダブりテスト",
        email: user.email,
        password: "password"
      )
      still_user_mail = user.email
      params = { user: { email: user.email, password: new_user.password } } 
      post '/api/v1/users', xhr: true, params: params
      expect(response).to have_http_status "200"
      json = JSON.parse(response.body)
      expect(json).to eq("color"=>"#D50000", "msg"=>"すでに会員登録されております😭")
    end

    it "Userがアクティブである事のテスト" do
      expect(user.activated).to be true 
    end

    it "ログインの確認テスト" do
      params = { auth: { email: user.email, password: user.password } } 
      login(params)
      json = JSON.parse(response.body)
      # puts json
      # httpのステータスは200かテスト
      expect(response).to have_http_status "200"
      ##############################################
      # ログイン後リフレッシュトークンの確認テスト #
      ##############################################
      post '/api/v1/auth_token/refresh', xhr: true
      expect(response).to have_http_status "200"
      user.reload
      # リロードしてもrefresh_jtiカラムにがnilになっていないか
      expect(user.refresh_jti).to_not be_nil
    end
  end

  describe "ログアウト関係のテスト" do
    let(:user) { FactoryBot.create(:user) }

    it "正常にログアウト出来ている" do
      # 正常にログインする
      params = { auth: { email: user.email, password: user.password } } 
      login(params)
      expect(response).to have_http_status "200"
      cookies[UserAuth.session_key.to_s]
      # ログインしているのでsessionにtokenがある
      expect(cookies[UserAuth.session_key.to_s]).to_not be_blank
      logout
      # ログアウトしたのでsessionのtokenがblankになる。
      expect(cookies[UserAuth.session_key.to_s]).to be_blank
    end
  end

  


 

end
