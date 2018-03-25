
# frozen_string_literal: true

class GraphqlController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!

  def execute
    variables = ensure_hash(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    result = ZestySchema.execute(query, variables: variables, context: build_context,
                                        operation_name: operation_name)
    render json: result
  end

  private

  def build_context
    {
      current_user: current_user,
      host: request.base_url,
      url_helpers: Rails.application.routes.url_helpers
    }
  end

  # Handle form data, JSON body, or a blank value
  def ensure_hash(ambiguous_param)
    return {} if ambiguous_param.blank?
    case ambiguous_param
    when String
      ensure_hash(JSON.parse(ambiguous_param))
    when Hash, ActionController::Parameters
      ambiguous_param
    else
      fail ArgumentError, "Unexpected parameter: #{ambiguous_param}"
    end
  end
end
