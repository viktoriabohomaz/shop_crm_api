module Mutations
  class UserMutations < BaseMutation
    argument :id, ID, required: false
    argument :email, String, required: true
    argument :first_name, String, required: true
    argument :last_name, String, required: true
    argument :is_admin, Boolean, required: false

    field :user, Types::UserType, null: true
    field :errors, [String], null: false

    def create_user
      authorize user, :create?
      user = User.new(user_params)

      if user.save
        { user:, errors: [] }
      else
        { user: nil, errors: user.errors.full_messages }
      end
    end

    def update_user
      authorize user, :update?
      user = User.find_by(id:)

      if user.update(user_params)
        { user:, errors: [] }
      else
        { user: nil, errors: user.errors.full_messages }
      end
    end

    def delete_user
      authorize user, :destroy?
      user = User.find_by(id:)

      if user.destroy
        { user:, errors: [] }
      else
        { user: nil, errors: user.errors.full_messages }
      end
    end

    def change_admin_status
      authorize user, :change_admin_status?
      user = User.find_by(id:)

      user.is_admin = is_admin
      if user.save
        { user:, errors: [] }
      else
        { user: nil, errors: user.errors.full_messages }
      end
    end

    private

    def user_params
      {
        email:,
        first_name:,
        last_name:,
        is_admin:
      }
    end
  end
end
