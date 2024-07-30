require 'rails_helper'

RSpec.describe Mutations::CustomerMutations, type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:context) { { current_user: user } }

  describe '#create_customer' do
    let(:mutation) do
      <<~GRAPHQL
        mutation($firstName: String!, $lastName: String!, $photo: String, $createdById: ID!, $updatedById: ID) {
          createCustomer(firstName: $firstName, lastName: $lastName, photo: $photo, createdById: $createdById, updatedById: $updatedById) {
            customer {
              id
              firstName
              lastName
              photo
            }
            errors
          }
        }
      GRAPHQL
    end

    it 'creates a new customer' do
      variables = {
        first_name: 'John',
        last_name: 'Doe',
        photo: 'photo_url',
        created_by_id: user.id,
        updated_by_id: user.id
      }

      post '/graphql', params: { query: mutation, variables: }
      json = JSON.parse(response.body)

      expect(response).to have_http_status(:success)
      expect(json['data']['createCustomer']['errors']).to be_empty
      expect(Customer.find(json['data']['createCustomer']['customer']['id']).first_name).to eq('John')
    end
  end

  describe '#update_customer' do
    let(:customer) { FactoryBot.create(:customer, created_by: user, updated_by: user) }
    let(:mutation) do
      <<~GRAPHQL
        mutation($id: ID!, $firstName: String, $lastName: String, $photo: String) {
          updateCustomer(id: $id, firstName: $firstName, lastName: $lastName, photo: $photo) {
            customer {
              id
              firstName
              lastName
              photo
            }
            errors
          }
        }
      GRAPHQL
    end

    it 'updates an existing customer' do
      variables = {
        id: customer.id,
        first_name: 'Jane',
        last_name: 'Doe',
        photo: 'new_photo_url'
      }

      post '/graphql', params: { query: mutation, variables: }
      json = JSON.parse(response.body)

      expect(response).to have_http_status(:success)
      expect(json['data']['updateCustomer']['errors']).to be_empty
      expect(Customer.find(customer.id).first_name).to eq('Jane')
    end
  end

  describe '#delete_customer' do
    let(:customer) { FactoryBot.create(:customer, created_by: user, updated_by: user) }
    let(:mutation) do
      <<~GRAPHQL
        mutation($id: ID!) {
          deleteCustomer(id: $id) {
            customer {
              id
              firstName
            }
            errors
          }
        }
      GRAPHQL
    end

    it 'soft deletes an existing customer' do
      variables = { id: customer.id }

      post '/graphql', params: { query: mutation, variables: }
      json = JSON.parse(response.body)

      expect(response).to have_http_status(:success)
      expect(json['data']['deleteCustomer']['errors']).to be_empty
      expect(Customer.with_deleted.find_by(id: customer.id)).to be_nil
      expect(Customer.only_deleted.find_by(id: customer.id)).not_to be_nil
    end
  end
end
