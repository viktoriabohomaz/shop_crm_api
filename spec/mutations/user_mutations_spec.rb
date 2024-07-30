require 'rails_helper'

RSpec.describe Mutations::UserMutations, type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:context) { { current_user: user } }

  describe '#create_user' do
    let(:mutation) do
      <<~GRAPHQL
        mutation($email: String!, $first_name: String!, $last_name: String!, $is_admin: Boolean) {
          createUser(email: $email, firstName: $first_name, lastName: $last_name, isAdmin: $is_admin) {
            user {
              id
              email
              firstName
              lastName
              isAdmin
            }
            errors
          }
        }
      GRAPHQL
    end

    it 'creates a new user' do
      variables = {
        email: 'newuser@example.com',
        first_name: 'John',
        last_name: 'Doe',
        is_admin: false
      }

      post '/graphql', params: { query: mutation, variables: }
      json = JSON.parse(response.body)

      expect(response).to have_http_status(:success)
      expect(json['data']['createUser']['errors']).to be_empty
      expect(User.find(json['data']['createUser']['user']['id']).email).to eq('newuser@example.com')
    end
  end

  describe '#update_user' do
    let(:mutation) do
      <<~GRAPHQL
        mutation($id: ID!, $email: String, $firstName: String, $lastName: String, $isAdmin: Boolean) {
          updateUser(id: $id, email: $email, firstName: $firstName, lastName: $lastName, isAdmin: $isAdmin) {
            user {
              id
              email
              firstName
              lastName
              isAdmin
            }
            errors
          }
        }
      GRAPHQL
    end

    it 'updates an existing user' do
      variables = {
        id: user.id,
        email: 'updated@example.com',
        first_name: 'Jane',
        last_name: 'Doe',
        is_admin: true
      }

      post '/graphql', params: { query: mutation, variables: }
      json = JSON.parse(response.body)

      expect(response).to have_http_status(:success)
      expect(json['data']['updateUser']['errors']).to be_empty
      expect(User.find(user.id).email).to eq('updated@example.com')
    end
  end

  describe '#delete_user' do
    let(:mutation) do
      <<~GRAPHQL
        mutation($id: ID!) {
          deleteUser(id: $id) {
            user {
              id
              email
            }
            errors
          }
        }
      GRAPHQL
    end

    it 'soft deletes an existing user' do
      user = FactoryBot.create(:user)
      variables = { id: user.id }

      post '/graphql', params: { query: mutation, variables: }
      json = JSON.parse(response.body)

      expect(response).to have_http_status(:success)
      expect(json['data']['deleteUser']['errors']).to be_empty
      expect(User.with_deleted.find_by(id: user.id)).to be_nil
      expect(User.only_deleted.find_by(id: user.id)).not_to be_nil
    end
  end

  describe '#change_admin_status' do
    let(:mutation) do
      <<~GRAPHQL
        mutation($id: ID!, $isAdmin: Boolean!) {
          changeAdminStatus(id: $id, isAdmin: $isAdmin) {
            user {
              id
              isAdmin
            }
            errors
          }
        }
      GRAPHQL
    end

    it 'changes the admin status of a user' do
      variables = {
        id: user.id,
        is_admin: true
      }

      post '/graphql', params: { query: mutation, variables: }
      json = JSON.parse(response.body)

      expect(response).to have_http_status(:success)
      expect(json['data']['changeAdminStatus']['errors']).to be_empty
      expect(User.find(user.id).is_admin).to be(true)
    end
  end
end
