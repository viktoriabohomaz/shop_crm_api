module Mutations
  module CustomerMutations
    class CreateCustomer < BaseMutation
      argument :first_name, String, required: true
      argument :last_name, String, required: true
      argument :photo_base64, String, required: false
      argument :photo_file_name, String, required: false

      field :customer, Types::CustomerType, null: true
      field :errors, [String], null: false

      def resolve(first_name:, last_name:, photo_base64: nil, photo_file_name: nil)
        authorize context[:current_user], :create?, Customer

        customer = Customer.new(
          first_name: first_name.strip,
          last_name: last_name.strip,
          created_by_id: context[:current_user].id,
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
        upload_service = ImageUploadService.new(photo_base64: photo_base64, file_name: photo_file_name)
        upload_service.call

        customer.photo = File.new("tmp/#{photo_file_name}")
        return if customer.save

        { customer: nil, errors: customer.errors.full_messages }
      end
    end
  end
end
