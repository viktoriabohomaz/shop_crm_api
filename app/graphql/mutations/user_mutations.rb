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
      user = User.new(user_params)
      authorize user, :create?

      if user.save
        { user: user, errors: [] }
      else
        { user: nil, errors: user.errors.full_messages }
      end
    end

    def update_user
      user = User.find_by(id: id)
      authorize user, :update?

      if user.update(user_params)
        { user: user, errors: [] }
      else
        { user: nil, errors: user.errors.full_messages }
      end
    end

    def delete_user
      user = User.find_by(id: id)
      authorize user, :destroy?

      if user.destroy
        { user: user, errors: [] }
      else
        { user: nil, errors: user.errors.full_messages }
      end
    end

    def change_admin_status
      user = User.find_by(id: id)
      authorize user, :change_admin_status?

      user.is_admin = is_admin
      if user.save
        { user: user, errors: [] }
      else
        { user: nil, errors: user.errors.full_messages }
      end
    end

    private

    def user_params
      {
        email: email,
        first_name: first_name,
        last_name: last_name,
        is_admin: is_admin
      }
    end
  end
end
