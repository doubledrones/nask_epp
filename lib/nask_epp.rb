require "nask_epp/version"

module NaskEpp
  case NaskEpp_PROTOCOL_VERSION
  when "1.0"
    EPP_SCHEMA = "urn:ietf:params:xml:ns:epp-1.0"
    EPP_SCHEMA_LOCATION = EPP_SCHEMA + " epp-1.0.xsd"
    CONTACT_SCHEMA = "urn:ietf:params:xml:ns:contact-1.0"
    CONTACT_SCHEMA_LOCATION = CONTACT_SCHEMA + " contact-1.0.xsd"
    HOST_SCHEMA = "urn:ietf:params:xml:ns:host-1.0"
    HOST_SCHEMA_LOCATION = HOST_SCHEMA + " host-1.0.xsd"
    DOMAIN_SCHEMA = "urn:ietf:params:xml:ns:domain-1.0"
    DOMAIN_SCHEMA_LOCATION = DOMAIN_SCHEMA + " domain-1.0.xsd"
    EXTCON_SCHEMA = "http://www.dns.pl/NASK-EPP/extcon-1.0"
    EXTCON_SCHEMA_LOCATION = EXTCON_SCHEMA + " extcon-1.0.xsd"
    EXTDOM_SCHEMA = "http://www.dns.pl/NASK-EPP/extdom-1.0"
    EXTDOM_SCHEMA_LOCATION = EXTDOM_SCHEMA + " extdom-1.0.xsd"
    EXTREPORT_SCHEMA = "urn:ietf:params:xml:ns:extreport-1.0"
    EXTREPORT_SCHEMA_LOCATION = EXTREPORT_SCHEMA + " extreport-1.0.xsd"
    FUTURE_SCHEMA = "http://www.dns.pl/NASK-EPP/future-1.0"
    FUTURE_SCHEMA_LOCATION = FUTURE_SCHEMA + " future-1.0.xsd"
  when "3.0"
    EPP_SCHEMA = "http://www.dns.pl/nask-epp-schema/epp-2.0"
    EPP_SCHEMA_LOCATION = EPP_SCHEMA + " epp-2.0.xsd"
    CONTACT_SCHEMA = "http://www.dns.pl/nask-epp-schema/contact-2.0"
    CONTACT_SCHEMA_LOCATION = CONTACT_SCHEMA + " contact-2.0.xsd"
    HOST_SCHEMA = "http://www.dns.pl/nask-epp-schema/host-2.0"
    HOST_SCHEMA_LOCATION = HOST_SCHEMA + " host-2.0.xsd"
    DOMAIN_SCHEMA = "http://www.dns.pl/nask-epp-schema/domain-2.0"
    DOMAIN_SCHEMA_LOCATION = DOMAIN_SCHEMA + " domain-2.0.xsd"
    EXTCON_SCHEMA = "http://www.dns.pl/nask-epp-schema/extcon-2.0"
    EXTCON_SCHEMA_LOCATION = EXTCON_SCHEMA + " extcon-2.0.xsd"
    EXTDOM_SCHEMA = "http://www.dns.pl/nask-epp-schema/extdom-2.0"
    EXTDOM_SCHEMA_LOCATION = EXTDOM_SCHEMA + " extdom-2.0.xsd"
    EXTREPORT_SCHEMA = "http://www.dns.pl/nask-epp-schema/extreport-2.0"
    EXTREPORT_SCHEMA_LOCATION = EXTREPORT_SCHEMA + " extreport-2.0.xsd"
    FUTURE_SCHEMA = "http://www.dns.pl/nask-epp-schema/future-2.0"
    FUTURE_SCHEMA_LOCATION = FUTURE_SCHEMA + " future-2.0.xsd"
  end
end

require "nask_epp/base"
require "nask_epp/access"
require "nask_epp/contact_credentials"
require "nask_epp/contact"
require "nask_epp/host"
require "nask_epp/domain"
require "nask_epp/future"
require "nask_epp/prepaid"
require "nask_epp/extreport"
require "nask_epp/poll"

class Nask

  def initialize(user, password, prefix)
    @user = user
    @password = password
    @prefix = prefix
    @debug = ENV['DEBUG']
  end

  include NaskEpp::Base
  include NaskEpp::Access
  include NaskEpp::Contact
  include NaskEpp::Host
  include NaskEpp::Domain
  include NaskEpp::Future
  include NaskEpp::Prepaid
  include NaskEpp::Extreport
  include NaskEpp::Poll

end
