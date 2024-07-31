source 'https://rubygems.org'

ruby '3.2.4'

# Rails version as per Gemfile.lock
gem 'rails', '~> 7.1'

gem 'pg', '~> 1.5'

gem 'puma', '~> 6.4'

# GraphQL and related gems
gem 'graphiql-rails', '~> 1.10'
gem 'graphql', '~> 2.3'
gem 'graphql-docs', '~> 5.0'

# Authentication
gem 'jwt', '~> 2.8'
gem 'oauth2', '~> 2.0'

# Authorization
gem 'pundit', '~> 2.3'

# Image uploads
gem 'aws-sdk-s3', '~> 1.156'
gem 'paperclip', '~> 6.1'

# Soft delete
gem 'paranoia', '~> 2.6'

# Debugging
gem 'byebug', '~> 11.1'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '~> 1.18'

gem 'rack-cors', '~> 2.0'

group :development, :test do
  gem 'rspec-rails', '~> 6.1'
  gem 'rubocop', '~> 1.65'
end

group :test do
  gem 'factory_bot_rails', '~> 6.4'
  gem 'ffaker', '~> 2.23'
end

gem 'propshaft', '~> 0.9.0'
