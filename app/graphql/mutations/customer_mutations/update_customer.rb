module Mutations
  module CustomerMutations
    class UpdateCustomer < BaseMutation
      argument :id, ID, required: true
      argument :first_name, String, required: false
      argument :last_name, String, required: false
      argument :photo, String, required: false

      field :customer, Types::CustomerType, null: true
      field :errors, [String], null: false

      def resolve(id:, first_name: nil, last_name: nil, photo: nil)
        authorize context[:current_user], :update?, Customer

        customer = Customer.find_by(id:)

        if customer&.update(
          first_name:,
          last_name:,
          photo:,
          updated_by_id: context[:current_user].id
        )
          { customer:, errors: [] }
        else
          { customer: nil,
            errors: customer ? customer.errors.full_messages : ['Customer not found'] }
        end
      end
    end
  end
end
