class Customer < ApplicationRecord
  acts_as_paranoid

  ### Associations
  belongs_to :created_by, class_name: 'User'
  belongs_to :updated_by, class_name: 'User'

  ### Validations
  validates :first_name, :last_name, presence: true
  validates :created_by_id, :updated_by_id, presence: true

  has_attached_file :photo, styles: { medium: '300x300>', thumb: '100x100>' }
  validates_attachment_content_type :photo, content_type: ['image/jpeg', 'image/jpg', 'image/png']
end
