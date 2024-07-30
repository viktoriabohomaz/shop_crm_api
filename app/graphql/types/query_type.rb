module Types
  class QueryType < BaseObject
    field :list_customers, [Types::CustomerType], null: false,
                                                  description: 'Returns a list of all customers' do
      argument :include_deleted, Boolean, required: false, default_value: false,
                                          description: 'Flag to include soft-deleted customers'
    end

    def list_customers(include_deleted:)
      authorize Customer, :index?
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
      customer = Customer.find(id)
      authorize customer, :show?
      customer
    end

    field :list_users, [Types::UserType], null: false, description: 'Returns a list of all users' do
      argument :include_deleted, Boolean, required: false, default_value: false,
                                          description: 'Flag to include soft-deleted users'
    end

    def list_users(include_deleted:)
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
      user = User.find(id)
      authorize user, :show?
      user
    end
  end
end
