require 'spec_helper'

describe Puppet::Type.type(:ejbca_end_entity) do
  describe 'ensure' do
    let(:end_entity) do
      described_class.new(
        name: 'sample',
        ensure: :present,
      )
    end

    [:new, :revoked].each do |value|
      it "acknowledges that a #{value} end entity is present" do
        expect(end_entity.property(:ensure).insync?(value)).to be true
      end
    end
  end
end
