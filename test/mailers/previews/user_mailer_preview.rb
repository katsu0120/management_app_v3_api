# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/account_activation
  def account_activation
    user = User.first
    user.activation_token = user.encode_access_token(payload = {lifetime:1.hours})
    UserMailer.account_activation(user)
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/password_reset
  def password_reset
    user = User.first
    user.reset_token = user.encode_access_token(payload = {lifetime:1.hours})
    UserMailer.password_reset(user)
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/email_update
  def email_update
    user = User.first
    user.email_update_token = 'user2test@example.com'
    UserMailer.email_update(user)
  end

end
