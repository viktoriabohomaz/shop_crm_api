module Types
  class QueryType < BaseObject
    field :list_customers, [Types::CustomerType], null: false,
                                                  description: 'Returns a list of all customers' do
      argument :include_deleted, Boolean, required: false, default_value: false,
                                          description: 'Flag to include soft-deleted customers'
    end

    def list_customers(include_deleted:)
      authorize context[:current_user], :index?, Customer
      if include_deleted
        Customer.with_deleted
      else
        Customer.all
      end
    end

    field :customer, Types::CustomerType, null: false do
      argument :id, ID, required: true
    end

    def customer(id:)
      authorize context[:current_user], :show?, Customer
      Customer.find(id)
    end

    field :list_users, [Types::UserType], null: false, description: 'Returns a list of all users' do
      argument :include_deleted, Boolean, required: false, default_value: false,
                                          description: 'Flag to include soft-deleted users'
    end

    def list_users(include_deleted:)
      authorize context[:current_user], :index?, User
      if include_deleted
        User.with_deleted
      else
        User.all
      end
    end

    field :user, Types::UserType, null: false do
      argument :id, ID, required: true
    end

    def user(id:)
      authorize context[:current_user], :show, User
      User.find(id)
    end
  end
end
