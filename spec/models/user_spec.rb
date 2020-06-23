# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  it 'responds to included concern method' do
    user = described_class.new

    expect(user).not_to be_persisted
  end
end
