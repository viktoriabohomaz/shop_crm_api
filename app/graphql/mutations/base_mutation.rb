module Mutations
  class BaseMutation < GraphQL::Schema::RelayClassicMutation
    argument_class Types::BaseArgument
    field_class Types::BaseField
    input_object_class Types::BaseInputObject
    object_class Types::BaseObject

    def authorize(record, query)
      policy = Pundit.policy!(context[:current_user], record)
      return if policy.public_send(query)

      raise GraphQL::ExecutionError, 'Not authorized'
    end
  end
end
