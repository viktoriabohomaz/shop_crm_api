module Mutations
  class LoginMutations < BaseMutation
    argument :provider, String, required: true
    argument :token, String, required: true

    field :token, String, null: true
    field :errors, [String], null: false

    def resolve(provider:, token:)
      oauth_provider = get_oauth_provider(provider, token)
      return { token: nil, errors: ['Invalid provider'] } unless oauth_provider

      user_info = oauth_provider.user_info
      user = User.find_or_initialize_by(uid: user_info[:uid], provider:)
      user.assign_attributes(
        first_name: user_info[:first_name],
        last_name: user_info[:last_name],
        email: user_info[:email]
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
