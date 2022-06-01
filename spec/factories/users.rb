FactoryBot.define do
  factory :user, aliases: [:owner] do
    # seedのuserが20までいるので一応30から始める
    sequence(:id) { |n| "#{n}".to_i + 30  }
    sequence(:name) { |n| "factory_test_user#{n}" }
    sequence(:email) { |n| "factory_test_user#{n}@example.com" }
    sequence(:user_profile) { |n| "factory_test_user#{n}のプロフィールです" }
    password { "password" }
    activated { true }
    

  end
end
