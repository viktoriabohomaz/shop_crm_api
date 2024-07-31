module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :email, String, null: true
    field :first_name, String, null: false
    field :last_name, String, null: false
    field :is_admin, Boolean, null: false
    field :deleted_at, GraphQL::Types::ISO8601DateTime, null: true
  end
end
