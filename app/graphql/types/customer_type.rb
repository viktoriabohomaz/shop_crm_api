module Types
  class CustomerType < Types::BaseObject
    field :id, ID, null: false
    field :first_name, String, null: false
    field :last_name, String, null: false
    field :photo, String, null: false
    field :deleted_at, GraphQL::Types::ISO8601DateTime, null: true
    field :created_by, Types::UserType, null: false, method: :created_by
    field :updated_by, Types::UserType, null: false, method: :updated_by
  end
end
