require 'spec_helper'

describe Puppet::Type.type(:ejbca_end_entity).provider(:ejbcaws) do
  context 'exists?' do
    let(:resource) do
      Puppet::Type.type(:ejbca_end_entity).new(
        ensure: :present,
        name: 'sample',
        provider: described_class.name,
      )
    end
    let(:provider) { resource.provider }

    it 'does not exist' do
      allow(provider).to receive(:user).and_return(nil)

      expect(provider.exists?).to be false
    end
  end

  context 'generated?' do
    let(:resource) do
      Puppet::Type.type(:ejbca_end_entity).new(
        ensure: :present,
        name: 'sample',
        provider: described_class.name,
      )
    end
    let(:provider) { resource.provider }

    it 'exists' do
      allow(provider).to receive(:user).and_return(status: :generated)

      expect(provider.exists?).to be true
    end
    it 'is generated' do
      allow(provider).to receive(:user).and_return(status: :generated)

      expect(provider.generated?).to be true
    end
  end
end
