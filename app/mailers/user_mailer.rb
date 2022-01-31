class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.account_activation.subject
  #
  def account_activation(user)
    @user = user
    @url = "#{ ENV["ACCOUNT_ACTIVATIONS_URL"] }/account/activations?token=#{user.activation_token}"
    mail to: user.email, subject: "メールアドレスのご確認"
  end

  # 認証メール送信メソッド
#  def account_activation(user)
  # ① トークンの有効期限を決定（セキュリティ強化のため、2時間以内など短い時間を指定する）
  # @token_limit = User.timelimit(:long)
  # ② 認証を行うNuxtのリンクを添付する
  # user.activation_token => URLのクエリーにトークンを付与する
  # @url = "#{ ENV["BASE_URL"] }/account/activations?token=#{user.activation_token}"
  # mail to: user.email, subject: "メールアドレスのご確認"
#  end



  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset
    @greeting = "Hi"

    mail to: "to@example.org"
  end

end
