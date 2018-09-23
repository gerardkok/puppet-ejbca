require 'puppet/parameter/boolean'

Puppet::Type.newtype(:ejbca_end_entity) do
  newproperty(:ensure) do
    newvalue(:present) do
      provider.create unless provider.exists?
    end
    newvalue(:absent) do
      provider.destroy if provider.exists?
    end
    newvalue(:new) do
      provider.create
    end
    newvalue(:revoked) do
      raise Puppet::Error, 'Cannot revoke ejbca_end_entity that has not been generated' unless provider.generated?
      provider.revoke
    end
    def insync?(is)
      is.to_s == should.to_s || (is.to_s != 'absent' && should.to_s == 'present')
    end

    defaultto :present
  end

  newparam(:username, namevar: true) do
    desc 'Username'
  end

  newproperty(:ca_name) do
    desc 'Issueing CA'
  end

  newparam(:password) do
    desc 'Password or enrollment code'
  end

  newparam(:clear_pwd, boolean: true, parent: Puppet::Parameter::Boolean) do
    desc 'Store password in clear text?'

    defaultto :false
  end

  newparam(:revocation_reason) do
    desc 'Revocation reason'

    newvalues(:aacompromise, :affiliationchanged, :cacompromise, :certificatehold, :cessationofoperation, :keycompromise, :privilegeswithdrawn, :removefromcrl, :superseded, :unspecified)

    munge(&:to_s)

    defaultto :unspecified
  end

  newproperty(:subject_dn) do
    desc 'Subject DN'
  end

  newproperty(:email) do
    desc 'Email address'
  end

  newproperty(:subject_alt_name, array_matching: :all) do
    desc 'Subject Alternative Names'

    def insync?(is)
      is.to_set == should.to_set
    end

    defaultto []
  end

  newproperty(:token_type) do
    desc 'Token type'

    newvalues(:USERGENERATED, :P12, :JKS, :PEM)

    munge(&:to_s)

    defaultto :USERGENERATED
  end

  newproperty(:end_entity_profile_name) do
    desc 'End Entity Profile'

    defaultto 'EMPTY'
  end

  newproperty(:certificate_profile_name) do
    desc 'Certificate Profile'

    defaultto 'ENDUSER'
  end
end
