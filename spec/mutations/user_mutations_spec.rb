require 'rails_helper'

RSpec.describe 'UserMutations', type: :request do
  let(:admin_user) { FactoryBot.create(:user, :admin) }
  let(:regular_user) { FactoryBot.create(:user) }
  let(:user) { FactoryBot.create(:user) }
  let(:valid_attributes) do
    {
      email: 'new@example.com',
      first_name: 'Test',
      last_name: 'Name'
    }
  end

  def authenticate(user)
    JwtService.encode(user_id: user.id)
  end

  let(:mutation_create) do
    <<~GQL
      mutation {
        createUser(input: {
          email: "#{valid_attributes[:email]}"
          firstName: "#{valid_attributes[:first_name]}"
          lastName: "#{valid_attributes[:last_name]}"
        }) {
          user {
            email
            firstName
            lastName
          }
          errors
        }
      }
    GQL
  end

  let(:mutation_update) do
    <<~GQL
      mutation {
        updateUser(input: {
          id: "#{user.id}"
          email: "#{valid_attributes[:email]}"
          firstName: "#{valid_attributes[:first_name]}"
          lastName: "#{valid_attributes[:last_name]}"
        }) {
          user {
            email
            firstName
            lastName
          }
          errors
        }
      }
    GQL
  end

  let(:mutation_delete) do
    <<~GQL
      mutation {
        deleteUser(input: {
          id: "#{user.id}"
        }) {
          user {
            email
          }
          errors
        }
      }
    GQL
  end

  let(:mutation_change_admin_status) do
    <<~GQL
      mutation {
        changeAdminStatus(input: {
          id: "#{user.id}"
          isAdmin: true
        }) {
          user {
            isAdmin
          }
          errors
        }
      }
    GQL
  end

  describe 'Create User mutation' do
    it 'creates a new user when admin user is logged in' do
      post '/graphql', params: { query: mutation_create }, headers: { 'Authorization': "Bearer #{authenticate(admin_user)}" }
      
      json = JSON.parse(response.body)
      data = json['data']['createUser']

      expect(response).to have_http_status(:success)
      expect(json['errors']).to be_nil
      expect(data['user']['email']).to eq(valid_attributes[:email])
    end

    it 'returns errors when regular user tries to create a user' do
      post '/graphql', params: { query: mutation_create }, headers: { 'Authorization': "Bearer #{authenticate(regular_user)}" }
      
      json = JSON.parse(response.body)
      data = json['data']['createUser']

      expect(response).to have_http_status(:success)
      expect(json['errors'].first['message']).to eq('Not authorized')
    end
  end

  describe 'Update User mutation' do
    it 'updates the user when admin user is logged in' do
      post '/graphql', params: { query: mutation_update }, headers: { 'Authorization': "Bearer #{authenticate(admin_user)}" }
      
      json = JSON.parse(response.body)
      data = json['data']['updateUser']

      expect(response).to have_http_status(:success)
      expect(json['errors']).to be_nil
      expect(data['user']['email']).to eq(valid_attributes[:email])
    end

    it 'returns errors when regular user tries to update a user' do
      post '/graphql', params: { query: mutation_update }, headers: { 'Authorization': "Bearer #{authenticate(regular_user)}" }
      
      json = JSON.parse(response.body)
      expect(response).to have_http_status(:success)
      expect(json['errors'].first['message']).to eq('Not authorized')
    end
  end

  describe 'Delete User mutation' do
    it 'deletes the user when admin user is logged in' do
      post '/graphql', params: { query: mutation_delete }, headers: { 'Authorization': "Bearer #{authenticate(admin_user)}" }
      
      json = JSON.parse(response.body)
      data = json['data']['deleteUser']

      expect(response).to have_http_status(:success)
      expect(json['errors']).to be_nil
      expect(User.with_deleted.find_by(id: user.id)).to be_present
    end

    it 'returns errors when regular user tries to delete a user' do
      post '/graphql', params: { query: mutation_delete }, headers: { 'Authorization': "Bearer #{authenticate(regular_user)}" }
      
      json = JSON.parse(response.body)
      expect(response).to have_http_status(:success)
      expect(json['errors'].first['message']).to eq('Not authorized')
    end
  end

  describe 'Change Admin Status mutation' do
    it 'changes admin status when admin user is logged in' do
      post '/graphql', params: { query: mutation_change_admin_status }, headers: { 'Authorization': "Bearer #{authenticate(admin_user)}" }
      
      json = JSON.parse(response.body)
      data = json['data']['changeAdminStatus']

      expect(response).to have_http_status(:success)
      expect(json['errors']).to be_nil
      expect(User.find(user.id).is_admin).to be(true)
    end

    it 'returns errors when regular user tries to change admin status' do
      post '/graphql', params: { query: mutation_change_admin_status }, headers: { 'Authorization': "Bearer #{authenticate(regular_user)}" }
      
      json = JSON.parse(response.body)
      expect(response).to have_http_status(:success)
      expect(json['errors'].first['message']).to eq('Not authorized')
    end
  end
end
