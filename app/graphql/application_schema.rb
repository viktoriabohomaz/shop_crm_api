class ApplicationSchema < GraphQL::Schema
  # query(Types::QueryType)
  mutation(Types::MutationType)

  rescue_from(GraphQL::ExecutionError) do |exception|
    Rails.logger.error "GraphQL Execution Error: #{exception.message}"
    { errors: [{ message: exception.message }] }
  end

  max_query_string_tokens(5000)

  validate_max_errors(100)
end
