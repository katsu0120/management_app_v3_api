require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  
describe "account_activationメイラーテスト" do
  let(:user) { FactoryBot.create(:user) }
  let(:mail) { UserMailer.account_activation(user) }


  it "アクティベーションメールをユーザーのメールアドレスに送信する" do
    user.activation_token = user.encode_access_token(payload = {lifetime:1.hours})
    expect(mail.to).to eq [user.email]
  end

  it "アクティベーションメールをサポート用のメールアドレスから送信する" do
    user.activation_token = user.encode_access_token(payload = {lifetime:1.hours})
    expect(mail.from).to eq [ENV['USER_NAME']]
  end

  it "正しい件名で送信する" do
    user.activation_token = user.encode_access_token(payload = {lifetime:1.hours})
    expect(mail.subject).to eq "Mgt_App会員仮登録完了のおしらせ"
  end
end


describe "password_resetメイラーテスト" do
  let(:user) { FactoryBot.create(:user) }
  let(:mail) { UserMailer.password_reset(user) }

  it "パスワードリセットメールをユーザーのメールアドレスに送信する" do
    user.reset_token = user.encode_access_token(payload = {lifetime:1.hours})
    expect(mail.to).to eq [user.email]
  end

  it "パスワードリセットメールをサポート用のメールアドレスから送信する" do
    user.reset_token = user.encode_access_token(payload = {lifetime:1.hours})
    expect(mail.from).to eq [ENV['USER_NAME']]
  end

  it "正しい件名で送信する" do
    user.reset_token = user.encode_access_token(payload = {lifetime:1.hours})
    expect(mail.subject).to eq "Mgt_Appパスワードリセットメール"
  end
end

describe "password_updateメイラーテスト" do
  let(:user) { FactoryBot.create(:user) }
  let(:mail) { UserMailer.password_reset(user) }

  it "パスワード変更メールをユーザーのメールアドレスに送信する" do
    user.reset_token = user.encode_access_token(payload = {lifetime:1.hours})
    expect(mail.to).to eq [user.email]
  end

  it "パスワードリセットメールをサポート用のメールアドレスから送信する" do
    user.reset_token = user.encode_access_token(payload = {lifetime:1.hours})
    expect(mail.from).to eq [ENV['USER_NAME']]
  end

  it "正しい件名で送信する" do
    user.reset_token = user.encode_access_token(payload = {lifetime:1.hours})
    expect(mail.subject).to eq "Mgt_Appパスワードリセットメール"
  end
end


end
