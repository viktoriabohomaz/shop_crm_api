module Mutations
  class BaseMutation < GraphQL::Schema::RelayClassicMutation
    argument_class Types::BaseArgument
    field_class Types::BaseField
    input_object_class Types::BaseInputObject
    object_class Types::BaseObject

    def authorize(user, action, record_class)
      policy = Pundit.policy!(user, record_class)
      return if policy.public_send(action)

      raise GraphQL::ExecutionError, 'Not authorized'
    end
  end
end
