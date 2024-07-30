GraphQL::Docs.configure do |config|
  config.schema = ShopCrmApiSchema
  config.output_dir = Rails.root.join('public', 'graphql-docs')
end
