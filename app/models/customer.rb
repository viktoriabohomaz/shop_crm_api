class Customer < ApplicationRecord
  acts_as_paranoid

  ### Associations
  belongs_to :created_by, class_name: 'User'
  belongs_to :updated_by, class_name: 'User'

  ### Validations
  validates :first_name, :last_name, presence: true
  validates :created_by_id, :updated_by_id, presence: true
  validates :photo, content_type: ['image/png', 'image/jpeg', 'image/jpg'], size: { between: 1.kilobyte..10.megabytes , message: 'is not given between size' }

  has_one_attached :photo do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 100]
  end
end
