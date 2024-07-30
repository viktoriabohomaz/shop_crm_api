require 'rails_helper'

RSpec.describe Mutations::AuthMutations, type: :request do
  let(:provider_code) { 'valid_provider_code' }
  let(:provider_code_invalid) { 'invalid_provider_code' }
  let(:provider_code_nonexistent) { 'nonexistent_provider_code' }

  let(:user_info) do
    {
      'email' => 'user@example.com',
      'given_name' => 'First',
      'family_name' => 'Last'
    }
  end

  let(:decoded_token) { { 'user_id' => user.id } }
  let(:user) { create(:user, email: 'user@example.com') }

  before do
    allow(Oauth::Providers::Google).to receive(:new).and_return(double(user_info:))
    allow(JwtService).to receive(:encode).and_return('valid_jwt_token')
    allow(JwtService).to receive(:decode).with('valid_jwt_token').and_return(decoded_token)
  end

  describe 'successful authentication with valid provider code' do
    it 'returns a JWT token and no errors' do
      post '/graphql', params: { query:, variables: { code: provider_code } }

      json_response = JSON.parse(response.body)
      data = json_response['data']['AuthMutations']

      expect(data['token']).to eq('valid_jwt_token')
      expect(data['errors']).to be_empty
    end
  end

  describe 'successful authentication with nonexistent provider code' do
    before do
      allow(Oauth::Providers::Google).to receive(:new).and_raise(StandardError,
                                                                  'Provider not found')
    end

    it 'returns an error message' do
      post '/graphql', params: { query:, variables: { code: provider_code_nonexistent } }

      json_response = JSON.parse(response.body)
      data = json_response['data']['AuthMutations']

      expect(data['token']).to be_nil
      expect(data['errors']).to include('Provider not found')
    end
  end

  describe 'authentication failure with invalid provider code' do
    before do
      allow(Oauth::Providers::Google).to receive(:new).and_raise(StandardError, 'Invalid code')
    end

    it 'returns an error message' do
      post '/graphql', params: { query:, variables: { code: provider_code_invalid } }

      json_response = JSON.parse(response.body)
      data = json_response['data']['AuthMutations']

      expect(data['token']).to be_nil
      expect(data['errors']).to include('Invalid code')
    end
  end

  describe 'failure to save user' do
    before do
      allow_any_instance_of(User).to receive(:save).and_return(false)
      allow_any_instance_of(User).to receive_message_chain(:errors,
                                                           :full_messages).and_return(['Save failed'])
    end

    it 'returns validation errors' do
      post '/graphql', params: { query:, variables: { code: provider_code } }

      json_response = JSON.parse(response.body)
      data = json_response['data']['AuthMutations']

      expect(data['token']).to be_nil
      expect(data['errors']).to include('Save failed')
    end
  end

  def query
    <<-GRAPHQL
      mutation($code: String!) {
        AuthMutations(code: $code) {
          token
          errors
        }
      }
    GRAPHQL
  end
end
