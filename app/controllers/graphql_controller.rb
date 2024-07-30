class GraphqlController < ApplicationController
  before_action :authenticate_by_token!

  def execute
    query_string = params[:query]
    query_variables = params[:variables]
    context = { current_user: @current_user }
    
    result = ApplicationSchema.execute(
      query_string,
      variables: query_variables,
      context: context,
      operation_name: params[:operationName]
    )
    render json: result
  rescue StandardError => e
    raise e unless Rails.env.development?

    handle_error_in_development(e)
  end

  private

  def handle_error_in_development(e)
    logger.error e.message
    logger.error e.backtrace.join("\n")
    render json: { errors: [{ message: e.message, backtrace: e.backtrace }] }, status: 500
  end

  def authenticate_by_token!
    token = request.headers['Authorization']&.split(' ')&.last
    if token
      decoded_token = JwtService.decode(token)
      if decoded_token && decoded_token[:user_id]
        @current_user = Rails.cache.fetch("user_#{decoded_token[:user_id]}", expires_in: 2.hours) do
          User.find_by(id: decoded_token[:user_id])
        end
      end
    end
    @current_user ||= nil
  end
end
