
# frozen_string_literal: true

class GraphqlController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!

  def execute

    if params[:operations].present?
      # used for mapping just a single file:
      operations = ensure_hash(params[:operations])
      variables = ensure_hash(operations['variables'])
      variables["file"] = params["0"]
      operation_name = operations['operationName']
      query = operations['query']
    else
      variables = ensure_hash(params[:variables])
      query = params[:query]
      operation_name = params[:operationName]
    end
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
