module Mutations
  module UserMutations
    class UpdateUser < BaseMutation
      argument :id, ID, required: true
      argument :email, String, required: false
      argument :first_name, String, required: false
      argument :last_name, String, required: false
      argument :is_admin, Boolean, required: false

      field :user, Types::UserType, null: true
      field :errors, [String], null: false

      def resolve(id:, email: nil, first_name: nil, last_name: nil, is_admin: nil)
        authorize context[:current_user], :update?, User

        user = User.find_by(id:)

        if user&.update(email:, first_name:, last_name:, is_admin:)
          { user:, errors: [] }
        else
          { user: nil, errors: user.errors.full_messages }
        end
      end
    end
  end
end
