module Oauth::Providers
  class Google < Base
    GOOGLE_CLIENT_ID = ENV['GOOGLE_CLIENT_ID']
    GOOGLE_CLIENT_SECRET = ENV['GOOGLE_CLIENT_SECRET']

    GOOGLE_SITE = 'https://accounts.google.com'.freeze
    USER_INFO_URL = 'https://www.googleapis.com/oauth2/v3/userinfo'.freeze

    def user_info
      client = OAuth2::Client.new(GOOGLE_CLIENT_ID, GOOGLE_CLIENT_SECRET, site: GOOGLE_SITE)
      response = client.request(:get, USER_INFO_URL, params: { access_token: token })
      result_hash(response)
    rescue OAuth2::Error => e
      Rails.logger.error("OAuth2 Error: #{e.message}")
      { error: e.message }
    end

    def result_hash(response)
      result = JSON.parse(response.body)
      {        first_name: result['given_name']&.strip,
               last_name: result['family_name']&.strip,
               email: result['email']&.strip,
               uid: result['sub']&.strip }
    end
  end
end
