require 'spec_helper'

describe 'ejbca' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end

    ['mariadb', 'mysql'].each do |driver|
      context "#{driver} on #{os}" do
        let(:facts) { os_facts }
        let(:params) do
          { database_driver: driver }
        end

        it { is_expected.to contain_class('ejbca::database::mysql') }
        it { is_expected.not_to contain_class('ejbca::database::postgresql') }
      end
    end

    context "postgresql on #{os}" do
      let(:facts) { os_facts }
      let(:params) do
        { database_driver: 'postgresql' }
      end

      it { is_expected.not_to contain_class('ejbca::database::mysql') }
      it { is_expected.to contain_class('ejbca::database::postgresql') }
    end

    context "h2 on #{os}" do
      let(:facts) { os_facts }
      let(:params) do
        { database_driver: 'h2' }
      end

      it { is_expected.not_to contain_class('ejbca::database::mysql') }
      it { is_expected.not_to contain_class('ejbca::database::postgresql') }
    end
  end
end
