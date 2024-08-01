module Mutations
  module UserMutations
    class DeleteUser < BaseMutation
      argument :id, ID, required: true

      field :user, Types::UserType, null: true
      field :errors, [String], null: false

      def resolve(id:)
        authorize context[:current_user], :destroy?, User

        user = User.with_deleted.find_by(id:)

        if user&.destroy
          { user:, errors: [] }
        else
          { user: nil, errors: ['User not found'] }
        end
      end
    end
  end
end
