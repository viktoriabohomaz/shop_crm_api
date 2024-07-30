class GraphqlController < ApplicationController
  before_action :authenticate_user!

  def execute
    context = {
      current_user: current_user
    }
  result = ShopCrmApiSchema.execute(params[:query], variables: params[:variables], context: context, operation_name: params[:operationName])
    render json: result
  rescue => e
    raise e unless Rails.env.development?
    handle_error_in_development(e)
  end

  private

  def authenticate_user!
    token = request.headers['Authorization']&.split(' ')&.last
    decoded_token = JsonWebToken.decode(token)
    @current_user = User.find(decoded_token[:user_id]) if decoded_token
  rescue ActiveRecord::RecordNotFound, JWT::DecodeError
    render json: { errors: ['Unauthorized'] }, status: :unauthorized
  end

  def current_user
    @current_user
  end

  def handle_error_in_development(e)
    logger.error e.message
    logger.error e.backtrace.join("\n")
    render json: { errors: [{ message: e.message, backtrace: e.backtrace }] }, status: 500
  end
end
