# frozen_string_literal: true

RSpec.shared_context 'with graphql schema test' do
  let(:variables)      { {} }
  let(:resource_names) { [:user] }
  let(:resource)       { nil }
  let(:controller)     { instance_double(GraphqlDevise::GraphqlController) }
  let(:context) do
    { current_resource: resource, controller: controller, resource_name: resource_names }
  end
  let(:response) do
    schema.execute(query, context: context, variables: variables).deep_symbolize_keys
  end
end
