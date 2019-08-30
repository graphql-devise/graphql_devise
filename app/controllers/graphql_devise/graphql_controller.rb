require_dependency 'graphql_devise/application_controller'

module GraphqlDevise
  class GraphqlController < ApplicationController
    before_action :set_user_by_token

    def auth
      result = if params[:_json]
        GraphqlDevise::Schema.multiplex(
          params[:_json].map do |param|
            { query: param[:query] }.merge(execute_params(param))
          end
        )
      else
        GraphqlDevise::Schema.execute(params[:query], execute_params(params))
      end

      render json: result
    end

    attr_accessor :client_id, :token, :resource

    private

    def execute_params(item)
      {
        operation_name: item[:operationName],
        variables:      ensure_hash(item[:variables]),
        context:        {
          current_resource: @resource,
          controller:       self,
          resource_class:   resource_class
        }
      }
    end

    def ensure_hash(ambiguous_param)
      case ambiguous_param
      when String
        if ambiguous_param.present?
          ensure_hash(JSON.parse(ambiguous_param))
        else
          {}
        end
      when Hash, ActionController::Parameters
        ambiguous_param
      when nil
        {}
      else
        raise ArgumentError, "Unexpected parameter: #{ambiguous_param}"
      end
    end
  end
end
