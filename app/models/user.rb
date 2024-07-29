class User < ApplicationRecord
  acts_as_paranoid
  has_secure_password

  ### Associations
  has_many :created_customers, class_name: 'Customer', foreign_key: 'created_by_id'
  has_many :updated_customers, class_name: 'Customer', foreign_key: 'updated_by_id'
  def generate_jwt
    JWT.encode({ id:, exp: 60.days.from_now.to_i }, Rails.application.secrets.secret_key_base)
  end
end
