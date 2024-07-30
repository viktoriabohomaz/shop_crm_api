module Mutations
  module CustomerMutations
    class CreateCustomer < BaseMutation
      argument :first_name, String, required: true
      argument :last_name, String, required: true
      argument :photo, String, required: false
      argument :created_by_id, ID, required: true
      argument :updated_by_id, ID, required: true

      field :customer, Types::CustomerType, null: true
      field :errors, [String], null: false

      def resolve(first_name:, last_name:, photo: nil, created_by_id: nil, updated_by_id: nil)
        authorize context[:current_user], :create?, Customer

        customer = Customer.new(
          first_name: first_name,
          last_name: last_name,
          photo: photo,
          created_by: context[:current_user],
          updated_by: context[:current_user]
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
