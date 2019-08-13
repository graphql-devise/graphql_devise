require 'rails_helper'

RSpec.describe Post do
  it 'responds to id' do
    post = Post.new

    expect(post.respond_to?(:id)).to be_truthy
  end
end
