require 'rails_helper'

RSpec.describe GraphqlDevise::Model::WithEmailUpdater do
  describe '#call' do
    subject(:updater) { described_class.new(resource, attributes).call }

    context 'when the model does not have an unconfirmed_email column' do
      let(:resource) { create(:admin, :confirmed) }

      context 'when attributes contain email' do
        let(:attributes) { { email: 'new@gmail.com', schema_url: 'http://localhost/test', confirmation_success_url: 'https://google.com' } }

        it 'does not postpone email update' do
          expect do
            updater
            resource.reload
          end.to change(resource, :email).from(resource.email).to('new@gmail.com').and(
            change(resource, :uid).from(resource.uid).to('new@gmail.com')
          )
        end
      end
    end

    context 'when the model has an unconfirmed_email column' do
      let(:resource) { create(:user, :confirmed) }

      context 'when attributes do not contain email' do
        let(:attributes) { { name: 'Updated Name', schema_url: 'http://localhost/test', confirmation_success_url: 'https://google.com' } }

        it 'updates resource, ignores url params' do
          expect do
            updater
            resource.reload
          end.to change(resource, :name).from(resource.name).to('Updated Name')
        end
      end

      context 'when attributes contain email' do
        context 'when schema_url is missing' do
          let(:attributes) { { email: 'new@gmail.com', name: 'Updated Name' } }

          it 'raises an error' do
            expect { updater }.to raise_error(
              GraphqlDevise::Error,
              'Method `update_with_email` requires attributes `confirmation_success_url` and `schema_url` for email reconfirmation to work'
            )
          end
        end

        context 'when only confirmation_success_url is missing' do
          let(:attributes) { { email: 'new@gmail.com', name: 'Updated Name', schema_url: 'http://localhost/test' } }

          it 'uses DTA default_confirm_success_url on the email' do
            expect { updater }.to change(ActionMailer::Base.deliveries, :count).by(1)

            email = ActionMailer::Base.deliveries.first
            expect(email.body.decoded).to include(CGI.escape('https://google.com'))
          end
        end

        context 'when both required urls are provided' do
          let(:attributes) { { email: 'new@gmail.com', name: 'Updated Name', schema_url: 'http://localhost/test', confirmation_success_url: 'https://google.com' } }

          it 'postpones email update' do
            expect do
              updater
              resource.reload
            end.to not_change(resource, :email).from(resource.email).and(
              not_change(resource, :uid).from(resource.uid)
            ).and(
              change(resource, :unconfirmed_email).from(nil).to('new@gmail.com')
            ).and(
              change(resource, :name).from(resource.name).to('Updated Name')
            )
          end

          it 'sends out a confirmation email to the unconfirmed_email' do
            expect { updater }.to change(ActionMailer::Base.deliveries, :count).by(1)

            email = ActionMailer::Base.deliveries.first
            expect(email.to).to contain_exactly('new@gmail.com')
          end
        end
      end
    end
  end
end
