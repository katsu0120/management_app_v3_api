FactoryBot.define do
  factory :company do
    sequence(:id) { |n| "#{n}".to_i + 30 }
    sequence(:name) { |n| "FactoryBot_CompanyName#{n}" }
    association :owner

  end
end
