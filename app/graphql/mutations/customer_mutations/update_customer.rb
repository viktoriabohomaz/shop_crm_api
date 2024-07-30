module Mutations
  module CustomerMutations
    class UpdateCustomer < BaseMutation
      argument :id, ID, required: true
      argument :first_name, String, required: false
      argument :last_name, String, required: false
      argument :photo, String, required: false
      argument :updated_by_id, ID, required: true

      field :customer, Types::CustomerType, null: true
      field :errors, [String], null: false

      def resolve(id:, first_name: nil, last_name: nil, photo: nil, created_by_id: nil,
                  updated_by_id: nil)
        customer = Customer.find_by(id:)
        authorize context[:current_user], :update?, customer

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
