FactoryBot.define do
  factory :project do
    sequence(:title) { |n| "Factory_Project_title#{n}" }
    sequence(:content) { |n| "Factory_Project_content#{n}" }
    association :user
  end

  # task付きのプロジェクト
  trait :with_tasks do
    after(:create) {|project| create_list(:task, 5, project: project)} 
  end

end
