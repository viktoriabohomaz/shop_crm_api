module Types
  class BaseObject < GraphQL::Schema::Object
    edge_type_class(Types::BaseEdge)
    connection_type_class(Types::BaseConnection)

    def authorize(user, action, record_class)
      policy = Pundit.policy!(user, record_class)
      return if policy.public_send(action)

      raise GraphQL::ExecutionError, 'Not authorized'
    end
  end
end
