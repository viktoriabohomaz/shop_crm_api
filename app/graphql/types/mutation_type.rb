module Types
  class MutationType < Types::BaseObject
    field :create_user, mutation: Mutations::UserMutations::CreateUser
    field :update_user, mutation: Mutations::UserMutations::UpdateUser
    field :delete_user, mutation: Mutations::UserMutations::DeleteUser
    field :change_admin_status, mutation: Mutations::UserMutations::ChangeAdminStatus

    field :create_customer, mutation: Mutations::CustomerMutations::CreateCustomer
    field :update_customer, mutation: Mutations::CustomerMutations::UpdateCustomer
    field :delete_customer, mutation: Mutations::CustomerMutations::DeleteCustomer

    field :authentication_mutations, mutation: Mutations::AuthMutations
  end
end
