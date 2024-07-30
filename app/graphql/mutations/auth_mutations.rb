module Mutations
  class AuthMutations < BaseMutation
    argument :provider, String, required: true
    argument :token, String, required: true

    field :token, String, null: true
    field :errors, [String], null: false

    def resolve(provider:, token:)
      provider = get_oauth_provider(provider, token)
      return { token: nil, errors: ['Invalid provider'] } unless provider

      user_info = provider.user_info

      user = User.find_or_initialize_by(email: user_info['email'])
      user.assign_attributes(
        first_name: user_info['given_name'],
        last_name: user_info['family_name']
      )

      if user.save
        token = JwtService.encode(user_id: user.id)
        { token:, errors: [] }
      else
        { token: nil, errors: user.errors.full_messages }
      end
    rescue StandardError => e
      { token: nil, errors: [e.message] }
    end

    private

    def get_oauth_provider(provider_name, token)
      case provider_name.downcase
      when 'google'
        Oauth::Providers::Google.new(token)
      end
    end
  end
end
