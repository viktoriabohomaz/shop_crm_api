class JwtMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)

    token = request.get_header('HTTP_AUTHORIZATION')

    if token
      token = token.split(' ').last
      decoded_token = JwtService.decode(token)
      if decoded_token
        env['graphql.context'] ||= {}
        env['graphql.context'][:current_user] = User.find_by(id: decoded_token[:user_id])
      end
    end

    @app.call(env)
  end
end
