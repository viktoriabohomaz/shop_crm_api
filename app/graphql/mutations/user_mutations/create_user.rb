module Mutations
  module UserMutations
    class CreateUser < BaseMutation
      argument :email, String, required: true
      argument :first_name, String, required: false
      argument :last_name, String, required: false
      argument :is_admin, Boolean, required: false

      field :user, Types::UserType, null: true
      field :errors, [String], null: false

      def resolve(email:, first_name: nil, last_name: nil, is_admin: nil)
        authorize context[:current_user], :create?, User

        user = User.new(email:, first_name:, last_name:,
                        is_admin:)

        if user.save
          { user:, errors: [] }
        else
          { user: nil, errors: user.errors.full_messages }
        end
      end
    end
  end
end
