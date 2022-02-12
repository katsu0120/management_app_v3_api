class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.account_activation.subject
  #
  def account_activation(user)
    @user = user
    @url = "#{ ENV["ACCOUNT_ACTIVATIONS_URL"] }/account/activations?token=#{user.activation_token.token}"
    mail to: user.email, subject: "Mgt_App会員仮登録完了のおしらせ"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(user)
    @user = user
    @url = "#{ ENV["ACCOUNT_ACTIVATIONS_URL"] }/account/PasswordResetActivate?token=#{user.reset_token.token}"
    mail to: user.email, subject: "Mgt_Appパスワードリセットメール"
  end

end