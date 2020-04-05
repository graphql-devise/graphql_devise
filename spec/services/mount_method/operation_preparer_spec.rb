require 'spec_helper'

RSpec.describe GraphqlDevise::MountMethod::OperationPreparer do
  describe '#call' do
    subject { described_class.new(default_operations: default_operations).call }


  end
end
