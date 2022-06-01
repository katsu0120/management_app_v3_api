class Project < ApplicationRecord
  belongs_to :user
  has_many :tasks, dependent: :destroy
  # RSpec用。FactoryBot作成時に作成user指定する為に定義
  belongs_to :creator, class_name: 'User', foreign_key: :user_id
end
