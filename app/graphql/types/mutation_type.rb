module Types
  class MutationType < Types::BaseObject
    field :user_mutations, mutation: Mutations::UserMutations
    field :customer_mutations, mutation: Mutations::CustomerMutations
    field :authentication_mutations, mutation: Mutations::AuthMutations
  end
end
