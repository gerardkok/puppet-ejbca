require 'spec_helper'
require 'puppet_x/ejbcaws/client'

describe Ejbcaws::Client do
  context 'to_ejbcaws' do
    it 'converts user to ejbcaws format' do
      expect(described_class.to_ejbcaws(subject_dn: 'dn', status: :generated)).to eq(subject_d_n: 'dn', status: '40')
    end
  end

  context 'from_ejbcaws' do
    it 'converts user from ejbcaws format' do
      expect(described_class.from_ejbcaws(status: '50')).to eq(status: :revoked)
    end
  end
end
