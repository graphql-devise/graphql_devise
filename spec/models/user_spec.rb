require 'rails_helper'

RSpec.describe User do
  it 'responds to included concern method' do
    user = User.new

    expect(user.test).to eq('This is a test')
  end
end
