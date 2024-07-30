module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :email, String, null: false
    field :first_name, String, null: true
    field :last_name, String, null: true
    field :is_admin, Boolean, null: false
    field :deleted_at, GraphQL::Types::ISO8601DateTime, null: true
  end
end
