require 'rails_helper'

RSpec.describe 'loginMutations', type: :request do
  let(:provider) { 'google' }
  let(:token) { 'valid_token' }
  let(:user_info) do
    {
      'email' => 'test@example.com',
      'given_name' => 'Test',
      'family_name' => 'Name',
      'uid' => '1234'
    }
  end

  before do
    allow_any_instance_of(Oauth::Providers::Google).to receive(:user_info).and_return(user_info)
  end

  describe 'loginMutations mutation' do
    it 'returns a token when valid provider and token are provided' do
      mutation = <<~GQL
        mutation {
          loginMutations(input: {
            provider: "#{provider}"
            token: "#{token}"
          }) {
            token
            errors
          }
        }
      GQL

      post '/graphql', params: { query: mutation }

      json = JSON.parse(response.body)
      auth_mutations = json.dig('data', 'loginMutations')

      expect(response).to have_http_status(:success)
      expect(auth_mutations['errors']).to be_empty
      expect(auth_mutations['token']).not_to be_nil
    end

    it 'returns errors when an invalid provider is provided' do
      invalid_provider = 'invalid_provider'
      mutation = <<~GQL
        mutation {
          authMutations(input: {
            provider: "#{invalid_provider}"
            token: "#{token}"
          }) {
            token
            errors
          }
        }
      GQL

      post '/graphql', params: { query: mutation }

      json = JSON.parse(response.body)
      auth_mutations = json.dig('data', 'authMutations')

      expect(response).to have_http_status(:success)
      expect(auth_mutations['token']).to be_nil
    end

    it 'returns errors when an invalid token is provided' do
      invalid_token = 'invalid_token'
      mutation = <<~GQL
        mutation {
          loginMutations(input: {
            provider: "#{provider}"
            token: "#{invalid_token}"
          }) {
            token
            errors
          }
        }
      GQL

      allow_any_instance_of(Oauth::Providers::Google).to receive(:user_info).and_raise(
        StandardError, 'Invalid token'
      )

      post '/graphql', params: { query: mutation }

      json = JSON.parse(response.body)
      auth_mutations = json.dig('data', 'loginMutations')

      expect(response).to have_http_status(:success)
      expect(auth_mutations['token']).to be_nil
      expect(auth_mutations['errors']).to include('Invalid token')
    end
  end
end
