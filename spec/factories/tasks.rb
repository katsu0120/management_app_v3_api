FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "Factory_Task_title#{n}" }
    sequence(:content) { |n| "Factory_Task_content#{n}" }
    association :project
  end
end
