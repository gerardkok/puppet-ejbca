require 'openssl'
require 'savon' if Puppet.features.savon?

module Ejbcaws # rubocop:disable Style/ClassAndModuleChildren
  class Soap # rubocop:disable Style/Documentation
    def initialize(options = {})
      p12 = OpenSSL::PKCS12.new(File.read(options[:client_certificate_path]), options[:client_certificate_password])
      savon_config = {
        wsdl: 'https://localhost:8443/ejbca/ejbcaws/ejbcaws?wsdl',
        ssl_cert: p12.certificate,
        ssl_cert_key: p12.key,
        ssl_verify_mode: :none,
        headers: { 'SOAPAction' => '' },
      }
      @client ||= Savon.client(savon_config)
    end

    def request(action, message = {})
      response_action = "#{action}_response".to_sym
      response = @client.call(action, message: message)
      response.body[response_action]
    end
  end
end
