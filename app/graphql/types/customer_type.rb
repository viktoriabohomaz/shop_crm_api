module Types
  class CustomerType < Types::BaseObject
    field :id, ID, null: false
    field :first_name, String, null: false
    field :last_name, String, null: false
    field :photo_url, String, null: true
    field :deleted, Boolean, null: false
    field :created_by, Types::UserType, null: false
    field :updated_by, Types::UserType, null: false
  end
end
