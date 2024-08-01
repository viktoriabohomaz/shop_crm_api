class GraphqlController < ApplicationController
  before_action :authenticate_current_user!

  def execute
    query_string = params[:query]
    query_variables = params[:variables]
    context = { current_user: @current_user }

    result = ApplicationSchema.execute(
      query_string,
      variables: query_variables,
      context:,
      operation_name: params[:operationName]
    )
    render json: result
  rescue StandardError => e
    handle_error_in_development(e) if Rails.env.development?
  end

  private

  def handle_error_in_development(error)
    logger.error error.message
    logger.error error.backtrace.join("\n")
    render json: { errors: [{ message: error.message, backtrace: error.backtrace }] }, status: 500
  end

  def authenticate_current_user!
    token = request.headers['Authorization']&.split(' ')&.last
    return unless token

    decoded_token = JwtService.decode(token)
    return unless decoded_token && decoded_token[:user_id]

    @current_user = Rails.cache.fetch("user_#{decoded_token[:user_id]}", expires_in: 2.hours) do
      User.find_by(id: decoded_token[:user_id])
    end
  end
end
