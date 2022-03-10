require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = active_user
  end

  test "name_validation" do
    #入力必須
    user = User.new(email: "test@example.com", password: "password")
    user.save
    required_msg = ["名前を入力してください"]
    assert_equal(required_msg, user.errors.full_messages)

    #文字数30文字までテスト
    max = 30
    name = "a" * (max + 1)
    user.name = name 
    user.save
    maxlength_msg = ["名前は30文字以内で入力してください"]
    assert_equal(maxlength_msg, user.errors.full_messages) 

    #名前は30文字以内のユーザーは保存できているか
    name = "あ" * max
    user.name = name
    assert_difference("User.count", 1) do
      user.save
    end
  end

  #考えられるemailの形式を配列で入れて、@userのemailで登録できるか確認する為のメソッド。登録出来なかったら失敗となる。
  test "email validation should accept valid addresses" do

    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end
  
  #emailドメインをわざと間違っているのを入れて、弾かれたら成功。弾かれなかったら失敗とする
   test "email validation should reject invalid addresses" do

    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end
  


  test "email_validation" do
    #入力必須
    user = User.new(name: "test", password: "password")
    user.save
    required_msg = ["メールアドレスを入力してください"]
    assert_equal(required_msg, user.errors.full_messages)

    #255文字制限
    max = 255
    domain = "@example.com"
    email = "a" * (max + 1 - domain.length) + domain
    assert max < email.length
    user.email = email 
    user.save
    maxlength_msg = ["メールアドレスは#{max}文字以内で入力してください"]
    assert_equal(maxlength_msg, user.errors.full_messages) 

    #正しい書式は保存できているか
    ok_emails = %w[
      A@EX.COM
      a-_@e-x.c-o_m.j_p
      a.a@ex.com
      a@e.co.js
      1.1@ex.com
      a.a+a@ex.com
    ]
    ok_emails.each do |email|
      user.email = email
      assert user.save
      
    end
    #間違った書式はエラーを吐いているか
    ng_emails = %w[
      aaa
      a.ex.com
      メール@ex.com
      a~a@ex.com
      a@|.com
      a@ex.
      .a@ex.com
      a＠ex.com
      Ａ@ex.com
      a@?,com
      １@ex.com
      "a"@ex.com
      a@ex@co.jp
    ]
    ng_emails.each do |email|
      user.email = email
      user.save
      format_msg = ["メールアドレスは不正な値です"]
      assert_equal(format_msg, user.errors.full_messages)
    end
  end

    # emailが小文字かされているか 
  test "email_downcase" do
    email = "USER@EXAMPLE.COM"
    user = User.new(email: email)
    user.save
    assert user.email == email.downcase
  end

  test "active_user_uniqueness" do
   email = "test@example.com"

    #アクティブユーザーがいない場合、同じemailが保存できているか
    count = 3
    assert_difference("User.count", count) do
      count.times do |n|
        User.create(name: "test#{n}", email: email, password: "password")
      end
    end

    #アクティブユーザーがいる場合、同じemailでバリデーションエラーを吐いているか
    active_user = User.find_by(email: email)
    active_user.update!(activated: true)
    assert active_user.activated

    assert_no_difference("User.count") do
      user = User.new(name: "test", email: email, password: "password")
      user.save
      uniqueness_msg = ["メールアドレスはすでに存在します"]
      assert_equal(uniqueness_msg, user.errors.full_messages)
    end  

    #アクティブユーザーがいなくなった場合、同じemailが保存できているか
    active_user.destroy!
    assert_difference("User.count", 1) do
      User.create(name: "test", email: email, password: "password", activated: true)
    end
    #アクティブユーザーのemailの一意性は保たれているか
    assert_equal(1, User.where(email: email, activated: true).count)
  end

   test "password_validation" do
    # 入力必須
    user = User.new(name: "test", email: "test@example.com")
    user.save
    required_msg = ["パスワードを入力してください"]
    assert_equal(required_msg, user.errors.full_messages)

    # min文字以上
    min = 8
    user.password = "a" * (min - 1)
    user.save
    minlength_msg = ["パスワードは8文字以上で入力してください"]
    assert_equal(minlength_msg, user.errors.full_messages)

    # max文字以下
    max = 72
    user.password = "a" * (max + 1)
    user.save
    maxlength_msg = ["パスワードは72文字以内で入力してください"]
    assert_equal(maxlength_msg, user.errors.full_messages)

    # 書式チェック VALID_PASSWORD_REGEX = /\A[\w\-]+\z/
    ok_passwords = %w(
      pass---word
      ________
      12341234
      ____pass
      pass----
      PASSWORD
    )
    ok_passwords.each do |pass|
      user.password = pass
      assert user.save
    end

    ng_passwords = %w(
      pass/word
      pass.word
      |~=?+"a"
      １２３４５６７８
      ＡＢＣＤＥＦＧＨ
      password@
    )
    format_msg = ["パスワードは半角英数字、ﾊｲﾌﾝ、ｱﾝﾀﾞｰﾊﾞｰが使えます"]
    ng_passwords.each do |pass|
      user.password = pass
      user.save
      assert_equal(format_msg, user.errors.full_messages)
    end
   end

end
