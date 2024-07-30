GraphQL::Rails::Schema.define do
  use JwtMiddleware

  query_class QueryType
  mutation_class MutationType

  context do
    current_user: nil
  end

  rescue_from(GraphQL::ExecutionError) do |exception|
    Rails.logger.error "GraphQL Execution Error: #{exception.message}"
    
    { errors: [{ message: exception.message }] }
  end

  GraphQL::Docs.configure do |config|
    config.schema = ApplicationSchema
    config.output_dir = Rails.root.join('public', 'graphql-docs')
  end
end