RSpec.shared_context 'with graphql schema test' do
  let(:variables)  { {} }
  let(:resource)   { nil }
  let(:controller) { instance_double(GraphqlDevise::GraphqlController) }
  let(:context)    { { current_resource: resource, controller: controller } }
  let(:response) do
    schema.execute(query, context: context, variables: variables).deep_symbolize_keys
  end
end
