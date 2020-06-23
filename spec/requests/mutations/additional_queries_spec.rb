# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Additional Queries' do
  include_context 'with graphql query request'

  let(:public_user) { create(:user, :confirmed) }

  context 'when using the user model' do
    let(:query) do
      <<-GRAPHQL
        query {
          publicUser(
            id: #{public_user.id}
          ) {
            email
            name
          }
        }
      GRAPHQL
    end

    before { post_request }

    it 'fetches a user by ID' do
      expect(json_response[:data][:publicUser]).to include(
        email: public_user.email,
        name:  public_user.name
      )
    end
  end
end
