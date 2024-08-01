require 'rails_helper'

RSpec.describe 'CustomerMutations', type: :request do
  let(:admin_user) { FactoryBot.create(:user, :admin) }
  let(:regular_user) { FactoryBot.create(:user) }
  let(:customer) { FactoryBot.create(:customer) }
  let(:valid_attributes) do
    {
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
        createCustomer(input: {
          firstName: "#{valid_attributes[:first_name]}"
          lastName: "#{valid_attributes[:last_name]}"
        }) {
          customer {
            id
            firstName
            lastName
            createdBy {
              id
              email
              firstName
              lastName
            }
            updatedBy {
              id
              email
              firstName
              lastName
            }
          }
          errors
        }
      }
    GQL
  end

  let(:mutation_update) do
    <<~GQL
      mutation {
        updateCustomer(input: {
          id: "#{customer.id}"
          firstName: "#{valid_attributes[:first_name]}"
          lastName: "#{valid_attributes[:last_name]}"
        }) {
          customer {
            id
            firstName
            lastName
            createdBy {
              id
              email
              firstName
              lastName
            }
            updatedBy {
              id
              email
              firstName
              lastName
            }
          }
          errors
        }
      }
    GQL
  end

  let(:mutation_delete) do
    <<~GQL
      mutation {
        deleteCustomer(input: {
          id: "#{customer.id}"
        }) {
          customer {
            id
          }
          errors
        }
      }
    GQL
  end

  describe 'Create Customer mutation' do
    it 'creates a new customer when admin user is logged in' do
      post '/graphql', params: { query: mutation_create },
                       headers: { 'Authorization': "Bearer #{authenticate(admin_user)}" }

      json = JSON.parse(response.body)
      data = json['data']['createCustomer']

      expect(response).to have_http_status(:success)
      expect(json['errors']).to be_nil
      expect(data['customer']['firstName']).to eq(valid_attributes[:first_name])
      expect(data['customer']['lastName']).to eq(valid_attributes[:last_name])
      expect(data['customer']['createdBy']['id']).to eq(admin_user.id.to_s)
    end

    it 'creates a new customer when regular user is logged in' do
      post '/graphql', params: { query: mutation_create },
                       headers: { 'Authorization': "Bearer #{authenticate(regular_user)}" }

      json = JSON.parse(response.body)
      data = json['data']['createCustomer']

      expect(response).to have_http_status(:success)
      expect(json['errors']).to be_nil
      expect(data['customer']['firstName']).to eq(valid_attributes[:first_name])
      expect(data['customer']['lastName']).to eq(valid_attributes[:last_name])
      expect(data['customer']['createdBy']['id']).to eq(regular_user.id.to_s)
    end
  end

  describe 'Update Customer mutation' do
    it 'updates the customer when admin user is logged in' do
      post '/graphql', params: { query: mutation_update },
                       headers: { 'Authorization': "Bearer #{authenticate(admin_user)}" }
      json = JSON.parse(response.body)
      data = json['data']['updateCustomer']

      expect(response).to have_http_status(:success)
      expect(json['errors']).to be_nil
      expect(data['customer']['firstName']).to eq(valid_attributes[:first_name])
      expect(data['customer']['lastName']).to eq(valid_attributes[:last_name])
      expect(data['customer']['updatedBy']['id']).to eq(admin_user.id.to_s)
    end

    it 'updates the customer when regular user is logged in' do
      post '/graphql', params: { query: mutation_update },
                       headers: { 'Authorization': "Bearer #{authenticate(regular_user)}" }
      json = JSON.parse(response.body)
      data = json['data']['updateCustomer']
      expect(response).to have_http_status(:success)
      expect(json['errors']).to be_nil
      expect(data['customer']['firstName']).to eq(valid_attributes[:first_name])
      expect(data['customer']['lastName']).to eq(valid_attributes[:last_name])
      expect(data['customer']['updatedBy']['id']).to eq(regular_user.id.to_s)
    end
  end

  describe 'Delete Customer mutation' do
    it 'deletes the customer when admin user is logged in' do
      post '/graphql', params: { query: mutation_delete },
                       headers: { 'Authorization': "Bearer #{authenticate(admin_user)}" }
      json = JSON.parse(response.body)
      json['data']['deleteCustomer']

      expect(response).to have_http_status(:success)
      expect(json['errors']).to be_nil
      expect(Customer.with_deleted.find_by(id: customer.id).deleted_at).not_to be_nil
    end

    it 'deletes the customer when regular user is logged in' do
      post '/graphql', params: { query: mutation_delete },
                       headers: { 'Authorization': "Bearer #{authenticate(regular_user)}" }
      json = JSON.parse(response.body)
      json['data']['deleteCustomer']

      expect(response).to have_http_status(:success)
      expect(json['errors']).to be_nil
      expect(Customer.with_deleted.find_by(id: customer.id).deleted_at).not_to be_nil
    end
  end
end
