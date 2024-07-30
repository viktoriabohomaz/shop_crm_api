module Oauth::Providers
  class Google < Base
    GOOGLE_CLIENT_ID = ENV['GOOGLE_CLIENT_ID']
    GOOGLE_CLIENT_SECRET = ENV['GOOGLE_CLIENT_SECRET']
    GOOGLE_SITE = 'https://accounts.google.com'.freeze

    def user_info
      client = OAuth2::Client.new(GOOGLE_CLIENT_ID, GOOGLE_CLIENT_SECRET, site: GOOGLE_SITE)
      response = client.request(:get, '/oauth2/v3/userinfo', access_token: token)
      JSON.parse(response.body)
    end
  end
end
