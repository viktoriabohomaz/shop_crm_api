module Mutations
  class CustomerMutations < BaseMutation
    argument :id, ID, required: false
    argument :first_name, String, required: true
    argument :last_name, String, required: true
    argument :photo, String, required: false
    argument :created_by_id, ID, required: true
    argument :updated_by_id, ID, required: false

    field :customer, Types::CustomerType, null: true
    field :errors, [String], null: false

    def create_customer(args)
      customer = Customer.new(args.merge(created_by: context[:current_user], updated_by: context[:current_user]))
      authorize customer, :create?

      if customer.save
        { customer: customer, errors: [] }
      else
        { customer: nil, errors: customer.errors.full_messages }
      end
    end

    def update_customer(args)
      customer = Customer.find_by(id: args[:id])
      authorize customer, :update?

      if customer.update(args.merge(updated_by_id: context[:current_user].id))
        { customer: customer, errors: [] }
      else
        { customer: nil, errors: customer.errors.full_messages }
      end
    end

    def delete_customer(args)
      customer = Customer.with_deleted.find_by(id: args[:id])
      authorize customer, :destroy?

      if customer.destroy
        { customer: customer, errors: [] }
      else
        { customer: nil, errors: ["Failed to delete customer"] }
      end
    end

    private

    def customer_params
      {
        first_name: first_name,
        last_name: last_name,
        photo: photo,
        created_by_id: created_by_id,
        updated_by_id: updated_by_id
      }
    end
  end
end
