require "validator/email_validator"

class User < ApplicationRecord
  #Token生成モジュール
  include TokenGenerateService
  before_validation :downcase_email 
  has_many :projects, dependent: :destroy

  # authのcreate時にも発火してしまう可能性があるので検討
  # before_create :create_activation_digest

  # gem bcrypt
  has_secure_password

  # DBに保存せずに済む為、履歴を残さずにtokenを送れる仮想の登録場所のメソッド
  attr_accessor :remember_token, :activation_token, :reset_token

  validates :name, presence: true,
                   length: { maximum: 30, allow_blank: true }

  validates :email, presence: true,
                       email: { allow_blank: true }

  VALID_PASSWORD_REGEX = /\A[\w\-]+\z/
  validates :password, presence: true,
                      length: { minimum: 8,
                        allow_blank: true
                      },
                      format: {
                        with: VALID_PASSWORD_REGEX,
                        message: :invalid_password,
                        allow_blank: true
                      },
                      allow_nil: true 
                      
  ## methods
  # class method  ###########################
  class << self
    # emailからアクティブなユーザーを返す
    def find_by_activated(email)
      find_by(email: email, activated: true)
    end
  end
  # class method end #########################

  # 自分以外の同じemailのアクティブなユーザーがいる場合にtrueを返す
  def email_activated?
    users = User.where.not(id: id)
    users.find_by_activated(email).present?
  end
  
  # リフレッシュトークンのJWT IDを記憶する
  def remember(jti)
    update!(refresh_jti: jti)
  end
  
  # リフレッシュトークンのJWT IDを削除する
  def forget
    update!(refresh_jti: nil)
  end

  def response_json(payload = {})
    as_json(only: [:id, :name]).merge(payload).with_indifferent_access
  end

  # アカウントを有効にする
  def activate
    update_attribute(:activated, true)
    # update_attribute(:activated_at, Time.zone.now)
  end

  # 有効化用のメールを送信する
  # def send_activation_email
  #   mail = UserMailer.account_activation(self)
  #   # emailをmailerアクションで送信する(8bit = 日本語文字化け対応)
  #   mail.transport_encoding = "8bit" if Rails.env == "development"
  #   mail.deliver_now
  # end

  # 有効化用のメールを送信する
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返す
  # まだ使わないけど、URL暗号化する時に使う。
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # 有効化トークンとダイジェストを作成および代入する
  def create_activation_digest
    # self.activation_token  = self.to_refresh_token
    self.activation_token  = self.to_access_token
    # self.activation_token  = self.encode_access_token
  end

  private

    # email小文字化
    def downcase_email
      self.email.downcase! if email
    end


end
