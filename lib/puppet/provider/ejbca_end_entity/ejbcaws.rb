require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'puppet_x', 'ejbcaws', 'client'))

Puppet::Type.type(:ejbca_end_entity).provide(:ejbcaws) do
  confine feature: [:savon, :ejbcaws_accessible]

  mk_resource_methods

  NEW_USER_FIELDS ||= [
    :username,
    :ca_name,
    :password,
    :clear_pwd,
    :subject_dn,
    :email,
    :subject_alt_name,
    :token_type,
    :end_entity_profile_name,
    :certificate_profile_name,
  ].freeze

  def self.instances
    []
  end

  def initialize(value = {})
    super(value)
    @property_flush = {}
  end

  def exists?
    !user.nil?
  end

  def generated?
    exists? && user[:status] == :generated
  end

  def create
    @property_flush[:ensure] = :present
  end

  def destroy
    @property_flush[:ensure] = :absent
  end

  def revoke
    @property_flush[:ensure] = :revoked
  end

  def ensure
    exists? ? user[:status] : :absent
  end

  def ca_name
    user[:ca_name]
  end

  def ca_name=(value)
    @property_flush[:ca_name] = value
  end

  def subject_dn
    user[:subject_dn]
  end

  def subject_dn=(value)
    @property_flush[:subject_dn] = value
  end

  def email
    user[:email] || ''
  end

  def email=(value)
    @property_flush[:email] = value
  end

  def subject_alt_name
    user[:subject_alt_name].to_s.split(',').map(&:chomp)
  end

  def subject_alt_name=(value)
    @property_flush[:subject_alt_name] = value.join(',')
  end

  def token_type
    user[:token_type]
  end

  def token_type=(value)
    @property_flush[:token_type] = value
  end

  def end_entity_profile_name
    user[:end_entity_profile_name]
  end

  def end_entity_profile_name=(value)
    @property_flush[:end_entity_profile_name] = value
  end

  def certificate_profile_name
    user[:certificate_profile_name]
  end

  def certificate_profile_name=(value)
    @property_flush[:certificate_profile_name] = value
  end

  def flush
    if @property_flush[:ensure] == :absent
      Ejbcaws::Client.delete_user(@resource[:username], @resource[:revocation_reason])
    elsif @property_flush[:ensure] == :present
      Ejbcaws::Client.edit_user(new_user)
    elsif @property_flush[:ensure] == :revoked
      Ejbcaws::Client.revoke_user(@resource[:username], @resource[:revocation_reason])
    else
      u = user.merge(@property_flush)
      Ejbcaws::Client.edit_user(u)
    end
    @user = Ejbcaws::Client.find_user(@resource[:username])
  end

  def user
    @user ||= Ejbcaws::Client.find_user(@resource[:username])
  end

  def new_user
    user = @resource.to_hash.select { |key, _| NEW_USER_FIELDS.include?(key) }
    user[:status] = :new
    user
  end
end
