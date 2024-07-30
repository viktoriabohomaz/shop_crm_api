class User < ApplicationRecord
  acts_as_paranoid

  ### Associations
  has_many :created_customers, class_name: 'Customer', foreign_key: 'created_by_id'
  has_many :updated_customers, class_name: 'Customer', foreign_key: 'updated_by_id'
end
