ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

# gem minitest-reporters setup
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase

  #プロセスが分岐した直後に呼び出し
  parallelize_setup do |worker|
    # seedデータ読み込み
    load "#{Rails.root}/db/seeds.rb"
  end

  #並列テストの有効化、無効化
  # workers: プロセス数を渡す(2以上=>有効, 2未満=>無効)
  #number_of_processors =>使用しているマシン(Docker)のコア数が入る(4)
  parallelize(workers: :number_of_processors)

  # アクティブユーザーを返す
  def active_user
    User.find_by(activated: true)
  end

  # api path
  def api(path = "/")
    "/api/v1#{path}"
  end

  # 認可ヘッダ
  def auth(token)
    { Authorization: "Bearer #{token}" }
  end

  # 引数のparamsでログインを行う
  def login(params)
    post api("/auth_token"), xhr: true, params: params
  end

  # ログアウトapi
  def logout
    delete api("/auth_token"), xhr: true
  end

  # レスポンスJSONをハッシュで返す
  def res_body
    JSON.parse(@response.body)
  end

end

