source 'https://rubygems.org'

ruby '3.2.4'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.1.0'

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '>= 5.0'

# GraphQL
gem 'graphiql-rails', group: :development
gem 'graphql'
gem 'graphql-docs'

# Authentication
gem 'jwt'
gem 'oauth2'

# Authorization
gem 'pundit'

# Image uploads
gem 'aws-sdk-s3', '~> 1.48'
gem 'paperclip'

# Soft delete
gem 'paranoia'

# Debugging
gem 'byebug', platforms: %i[mri mingw x64_mingw]

# Swagger for API documentation
gem 'rswag'

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mswin mswin64 mingw x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin Ajax possible
gem 'rack-cors'

group :development, :test do
  gem 'rspec-rails'
  gem 'rubocop'
end

group :test do
  gem 'factory_bot_rails'
  gem 'ffaker'
end
