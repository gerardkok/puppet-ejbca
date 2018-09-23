Facter.add(:ejbcaversion) do
  setcode do
    if Puppet.features.ejbcaws_accessible?
      Ejbcaws::Client.version.scan(%r{^\s*EJBCA\s*([0-9\.]+)\s.*$}).flatten.first
    end
  end
end
