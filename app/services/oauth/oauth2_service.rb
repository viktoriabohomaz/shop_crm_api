module Oauth
  class Oauth2Service
    def initialize(provider_name, token)
      @provider_name = provider_name
      @token = token
    end

    def user_info
      provider_class = "OAuth2::Providers::#{provider_name.capitalize}".constantize
      provider = provider_class.new(@token)
      provider.user_info
    end

    private

    attr_reader :provider_name, :token
  end
end
