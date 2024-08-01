module Mutations
  module CustomerMutations
    class UpdateCustomer < BaseMutation
      argument :id, ID, required: true
      argument :first_name, String, required: false
      argument :last_name, String, required: false
      argument :photo_base64, String, required: false
      argument :photo_file_name, String, required: false

      field :customer, Types::CustomerType, null: true
      field :errors, [String], null: false

      def resolve(id:, first_name: nil, last_name: nil, photo_base64: nil, photo_file_name: nil)
        authorize context[:current_user], :update?, Customer

        customer = Customer.find_by(id:)

        return { customer: nil, errors: ['Customer not found'] } if customer.nil?

        customer.assign_attributes(
          first_name: first_name&.strip,
          last_name: last_name&.strip,
          updated_by_id: context[:current_user].id
        )

        if customer.save
          upload_photo(customer, photo_base64, photo_file_name) if photo_base64 && photo_file_name
          { customer:, errors: [] }
        else
          { customer: nil, errors: customer.errors.full_messages }
        end
      end

      private

      def upload_photo(customer, photo_base64, photo_file_name)
        upload_service = ImageUploadService.new(photo_base64:,
                                                file_name: photo_file_name)
        upload_service.call

        customer.photo = File.new("tmp/#{photo_file_name}")
        return if customer.save

        { customer: nil, errors: customer.errors.full_messages }
      end
    end
  end
end
