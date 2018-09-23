require 'puppet/util/feature'
require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'puppet_x', 'ejbcaws', 'client'))

Puppet.features.add(:ejbcaws_accessible) do
  begin
    Ejbcaws::Client.version.start_with?('EJBCA')
  rescue StandardError
    false
  end
end
