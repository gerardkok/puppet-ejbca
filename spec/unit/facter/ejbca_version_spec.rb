require 'spec_helper'
require 'puppet_x/ejbcaws/client'

describe 'Facter::Util::Fact' do
  before(:each) do
    Facter.clear
  end

  context 'ejbcaws accessible' do
    it do
      allow(Puppet.features).to receive(:ejbcaws_accessible?).and_return(true)
      allow(Ejbcaws::Client).to receive(:version).and_return('EJBCA 6.10.1.2 Community (r27920)')
      expect(Facter.fact(:ejbcaversion).value).to eql('6.10.1.2')
    end
  end
end
