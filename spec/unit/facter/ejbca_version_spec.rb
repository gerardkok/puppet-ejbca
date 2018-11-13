require 'spec_helper'
require 'facter/ejbca'

describe 'Facter::Util::Fact' do
  before(:each) do
    Facter.clear
  end

  context 'ejbcaws accessible' do
    it do
      allow(Puppet::Confine::Feature).to receive(:pass?).with(:ejbcaws_accessible).and_return(true)
      allow(Ejbcaws::Client).to receive(:version).and_return('EJBCA 6.10.1.2 Community')
      expect(Facter.fact(:ejbcaversion).value).to eql('6.10.1.2')
    end
  end
end
