class GraphqlController < ApplicationController
  def execute
    context = {
      current_user: context[:current_user]
    }
    result = ApplicationSchema.execute(
      params[:query],
      variables: params[:variables],
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
end
