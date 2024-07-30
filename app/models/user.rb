class User < ApplicationRecord
  acts_as_paranoid
  
  after_save :clear_cache

  ### Associations
  has_many :created_customers, class_name: 'Customer', foreign_key: 'created_by_id'
  has_many :updated_customers, class_name: 'Customer', foreign_key: 'updated_by_id'

  private

  def clear_cache
    Rails.cache.delete("user_#{id}")
  end
end
