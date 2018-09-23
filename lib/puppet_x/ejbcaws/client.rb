require 'yaml'
require 'puppet'
require File.expand_path(File.join(File.dirname(__FILE__), 'soap'))

module Ejbcaws # rubocop:disable Style/ClassAndModuleChildren
  class Client # rubocop:disable Style/Documentation
    STATUSES ||= {
      new: '10',
      failed: '11',
      initialized: '20',
      inprocess: '30',
      generated: '40',
      revoked: '50',
      historical: '60',
      keyrecovery: '70',
      waitingforapproval: '80',
    }.freeze
    REVOCATION_REASONS ||= {
      unspecified: '0',
      keycompromise: '1',
      cacompromise: '2',
      affiliationchanged: '3',
      superseded: '4',
      cessationofoperation: '5',
      certificatehold: '6',
      removefromcrl: '8',
      privilegeswithdrawn: '9',
      aacompromise: '10',
    }.freeze

    class << self
      def config_file
        @config_file ||= File.expand_path(File.join(Puppet.settings[:confdir], 'ejbcaws.yaml'))
      end

      def credentials
        @credentials ||= YAML.load_file(config_file).each_with_object({}) { |(k, v), memo| memo[k.to_sym] = v }
      end

      def client
        @client ||= Ejbcaws::Soap.new(credentials)
      rescue ArgumentError, Savon::SOAPFault => e
        raise Puppet::Error, "Cannot connect to endpoint: '#{e.message}'"
      end

      def to_ejbcaws(user)
        user[:subject_d_n] = user.delete(:subject_dn)
        user[:status] = STATUSES[user.delete(:status)]
        user
      end

      def from_ejbcaws(user)
        user[:status] = STATUSES.key(user.delete(:status))
        user
      end

      def version
        response = client.request(:get_ejbca_version)
        response[:return]
      end

      def find_user(username)
        response = client.request(:find_user, arg0: { matchwith: 0, matchtype: 0, matchvalue: username })
        response.key?(:return) ? from_ejbcaws(response[:return]) : nil
      end

      def edit_user(user)
        u = to_ejbcaws(user)
        client.request(:edit_user, arg0: u)
      end

      def delete_user(username, revocation_reason)
        reason = REVOCATION_REASONS[revocation_reason]
        client.request(:revoke_user, arg0: username, arg1: reason, arg2: true)
      end

      def revoke_user(username, revocation_reason)
        reason = REVOCATION_REASONS[revocation_reason]
        client.request(:revoke_user, arg0: username, arg1: reason, arg2: false)
      end
    end
  end
end
