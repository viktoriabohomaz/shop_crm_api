module Mutations
  class UserMutations < BaseMutation
    class ChangeAdminStatus < BaseMutation
      argument :id, ID, required: true
      argument :is_admin, Boolean, required: true

      field :user, Types::UserType, null: true
      field :errors, [String], null: false

      def resolve(id:, is_admin:)
        user = User.find_by(id: id)

        if user
          user.update(is_admin: is_admin)
          { user: user, errors: [] }
        else
          { user: nil, errors: ['User not found'] }
        end
      end
    end
  end
end
