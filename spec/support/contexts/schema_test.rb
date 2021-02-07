RSpec.shared_context 'with graphql schema test' do
  let(:variables)  { {} }
  let(:resource)   { nil }
  let(:controller) { instance_double(Api::V1::GraphqlController) }
  let(:context)    { { current_resource: resource, controller: controller } }
  let(:response) do
    schema.execute(query, context: context, variables: variables).deep_symbolize_keys
  end

  # before do
  #   allow_any_instance_of(GraphqlDevise::Mutations::Login).to receive(:set_auth_headers)
  #   allow(controller).to receive(:request).and_return(request)
  #   # allow(controller).to receive(:response).and_return(response)
  # end
end
