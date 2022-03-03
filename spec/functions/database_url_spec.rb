require 'spec_helper'

describe 'ejbca::database_url' do
  it { is_expected.to run.with_params('mariadb', 'some_db').and_return('jdbc:mysql://127.0.0.1:3306/some_db?characterEncoding=UTF-8') }
  it { is_expected.to run.with_params('mysql5', 'some_db').and_return('jdbc:mysql://127.0.0.1:3306/some_db?characterEncoding=UTF-8') }
  it { is_expected.to run.with_params('mysql8', 'some_db').and_return('jdbc:mysql://127.0.0.1:3306/some_db?characterEncoding=UTF-8') }
  it { is_expected.to run.with_params('postgresql', 'some_db').and_return('jdbc:postgresql://127.0.0.1/some_db') }
  it { is_expected.to run.with_params('h2', 'some_db').and_return('jdbc:h2:~/ejbcadb;DB_CLOSE_DELAY=-1') }
end
