class Company < ApplicationRecord
  belongs_to :owner, class_name: :User
  has_many   :users, class_name: :CompanyUser, foreign_key: "company_id", dependent: :destroy
  has_many :users_details, through: :users, source: :user
  has_many :projects
end
