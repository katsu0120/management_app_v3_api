require 'rails_helper'

RSpec.describe Company, type: :model do

  it "有効なファクトリカンパニーを持つかテスト" do
    expect(FactoryBot.build(:company)).to be_valid
  end

  it "ファクトリのCompanyのデータ作成のテスト" do
    puts "ファクトリのprojectの作成状況"
    company = FactoryBot.create(:company)
    puts "カンパニー情報"
    puts "#{company.inspect}"
    puts "カンパニーのオーナー"
    puts "#{company.owner.inspect}"
  end





end
