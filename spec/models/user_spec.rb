require 'rails_helper'

RSpec.describe User, type: :model do

  # presenceテストの短縮系
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :email }
  
  #length系
  it { is_expected.to validate_length_of(:name).is_at_most(30)}
  it { is_expected.to_not validate_length_of(:name).is_at_most(31)}
  # passwordは8文字以上
  it { is_expected.to validate_length_of(:password).is_at_least(8)}


  it "有効なファクトリユーザーを持つかテスト" do
    expect(FactoryBot.build(:user)).to be_valid
  end
  
  it "nameとemailとpasswordがあれば有効な状態である事" do
    user = User.new(
      name: "test",
      email: "test@example.com",
      password: "password"
    )
    expect(user).to be_valid
  end

  it "登録しようとしたemailがすでに登録されており、尚且つアクティブならtrueを返す(その後activatedがtrueに出来ない様にコントローラー設計している)" do
    FactoryBot.create(:user, email: "test@example.com", activated: true )
    user = FactoryBot.build(:user, email: "test@example.com", activated: false )
    expect(user.email_activated?).to be true
  end

  it "同じnameは無効な事を確認するテスト" do
    FactoryBot.create(:user, name: "test", activated: true)
    user = FactoryBot.build(:user, name: "test", activated: false)
    expect(user).to_not be_valid
  end



end
