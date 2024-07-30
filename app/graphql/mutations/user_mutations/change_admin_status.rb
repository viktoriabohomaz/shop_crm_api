module Mutations
  module UserMutations
    class ChangeAdminStatus < BaseMutation
      argument :id, ID, required: true
      argument :is_admin, Boolean, required: true

      field :user, Types::UserType, null: true
      field :errors, [String], null: false

      def resolve(id:, is_admin:)
        authorize context[:current_user], :change_admin_status?, User

        user = User.find_by(id:)

        if user
          if user.update(is_admin:)
            { user:, errors: [] }
          else
            { user: nil, errors: user.errors.full_messages }
          end
        else
          { user: nil, errors: ['User not found'] }
        end
      end
    end
  end
end
