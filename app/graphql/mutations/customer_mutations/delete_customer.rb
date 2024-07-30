module Mutations
  module CustomerMutations
    class DeleteCustomer < BaseMutation
      argument :id, ID, required: true

      field :customer, Types::CustomerType, null: true
      field :errors, [String], null: false

      def resolve(id:)
        authorize context[:current_user], :destroy?, customer
        customer = Customer.with_deleted.find_by(id: id)

        if customer&.destroy
          { customer:, errors: [] }
        else
          { customer: nil, errors: ['Failed to delete customer'] }
        end
      end
    end
  end
end
