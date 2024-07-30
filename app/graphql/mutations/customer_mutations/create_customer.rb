module Mutations
  module CustomerMutations
    class CreateCustomer < BaseMutation
      argument :first_name, String, required: true
      argument :last_name, String, required: true
      argument :photo, String, required: false

      field :customer, Types::CustomerType, null: true
      field :errors, [String], null: false

      def resolve(first_name:, last_name:, photo: nil)
        authorize context[:current_user], :create?, Customer
        customer = Customer.new(
          first_name:,
          last_name:,
          photo:,
          created_by_id: context[:current_user].id,
          updated_by_id: context[:current_user].id
        )
        if customer.save
          { customer:, errors: [] }
        else
          { customer: nil, errors: customer.errors.full_messages }
        end
      end
    end
  end
end
