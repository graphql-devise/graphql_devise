# frozen_string_literal: true

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

          context 'when email will not change' do
            let(:attributes) { { email: resource.email, name: 'changed' } }

            it 'updates name and does not raise an error' do
              expect do
                updater
                resource.reload
              end.to change(resource, :name).from(resource.name).to('changed').and(
                not_change(resource, :email).from(resource.email)
              ).and(
                not_change(ActionMailer::Base.deliveries, :count).from(0)
              )
            end
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

          context 'when email value is the same on the DB' do
            let(:attributes) { { email: resource.email, name: 'changed', schema_url: 'http://localhost/test', confirmation_success_url: 'https://google.com' } }

            it 'updates attributes and does not send confirmation email' do
              expect do
                updater
                resource.reload
              end.to change(resource, :name).from(resource.name).to('changed').and(
                not_change(resource, :email).from(resource.email)
              ).and(
                not_change(ActionMailer::Base.deliveries, :count).from(0)
              )
            end
          end

          context 'when provided params are invalid' do
            let(:attributes) { { email: 'newgmail.com', name: '', schema_url: 'http://localhost/test', confirmation_success_url: 'https://google.com' } }

            it 'returns false and adds errors to the model' do
              expect(updater).to be_falsey
              expect(resource.errors.full_messages).to contain_exactly(
                'Email is not an email',
                "Name can't be blank"
              )
            end
          end
        end
      end
    end
  end
end
