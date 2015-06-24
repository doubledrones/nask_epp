module NaskEpp::Domain

  XMLNS = case NaskEpp_PROTOCOL_VERSION
  when "1.0"
    "urn:ietf:params:xml:ns:domain-1.0"
  when "3.0"
    "http://www.dns.pl/nask-epp-schema/domain-2.0"
  end

  class DomainNotCreated < StandardError
  end

  class DomainNotPL < StandardError
  end

  def domain_create(domain_params)
    domain_create!(domain_params)
  rescue DomainNotCreated
    false
  rescue DomainNotPL
    false
  end

  def domain_create!(domain_params)
    raise DomainNotPL, "Domain is not .pl" unless domain_params[:name] !=~ /^[a-z0-9]*(\.?[a-z0-9]+)\.pl$/ix
    response_xml = request_xml(domain_create_xml(domain_params))
    if response_xml.search("result").first.attribute("code").value == "1000"
      true
    else
      raise DomainNotCreated, response_error(response_xml)
    end
  end

  def domain_delete(domain_name)
    request_element_attribute(domain_delete_xml(domain_name), :result, :code) == "1000"
  end

  def domain_remove_status(domain_name, status_name)
    request_element_attribute(domain_remove_status_xml(domain_name, status_name), :result, :code) == "1000"
  end

  def domain_info(domain_name, options = {})
    response_xml = request_xml(domain_info_xml(domain_name, options))
    if response_xml.search("result").first.attribute("code").value == "1000"
      {
        :name => domain_info_extract(response_xml, :name),
        :roid => domain_info_extract(response_xml, :roid),
        :exDate => domain_info_extract(response_xml, :exDate),
        :clID => domain_info_extract(response_xml, :clID),
        :pw => domain_info_extract(response_xml, :pw)
      }
    end
  end

  def domain_check(*domains_names)
    response_xml = request_xml(domain_check_xml(domains_names))
    if response_xml.search("result").first.attribute("code").value == "1000"
      domains_availability = {}
      domains_names.each_with_index do |domain_name, i|
        value = response_xml.xpath("//domain:name[contains(text(), \"#{domain_name}\")]", 'domain' => XMLNS).first.attribute("avail").value == "true"
        domains_availability["#{domain_name}"] = value
      end
      domains_availability.count == 1 ? domains_availability.first.last : domains_availability
    end
  end

  def domain_update(domain_name, domain_params)
    request_element_attribute(domain_update_xml(domain_name, domain_params), :result, :code) == "1000"
  end

  def domain_transfer(domain_name, domain_params)
    code = request_element_attribute(domain_transfer_xml(domain_name, domain_params), :result, :code)
    case domain_params[:op]
    when "request"
      code == "1001"
    when "query"
      code == "1000"
    end
  end

  def domain_renew(domain_name, domain_params)
    request_element_attribute(domain_renew_xml(domain_name, domain_params), :result, :code) == "1000"
  end

  def domain_list_hosts(domain_name)
    response_xml = request_xml(domain_info_xml(domain_name))
    response_xml.xpath("//domain:host", 'domain' => XMLNS).map(&:content)
  end

  private

    def domain_info_extract(response_xml, name)
      response_xml.xpath("//domain:#{name}", 'domain' => XMLNS).first.content
    rescue NoMethodError
      ""
    end

    def domain_create_xml_without_book_params(domain_params)
      if domain_params[:book]
        ""
      else
        (domain_params[:period] ? "<domain:period unit=\"y\">#{domain_params[:period]}</domain:period>" : "") +
        (domain_params[:registrant] ? "<domain:registrant>#{domain_params[:registrant]}</domain:registrant>" : "") +
        (domain_params[:contact] ? "<domain:contact type=\"#{domain_params[:contact_type]}\">#{domain_params[:contact]}</domain:contact>" : "")
      end
    end

    def domain_create_xml(domain_params)
      _domain_params = {:contact_type => "tech", :reason => "nice name"}
      _domain_params.merge!(domain_params)
"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>
<epp xmlns=\"#{NaskEpp::EPP_SCHEMA}\"
 xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
 xsi:schemaLocation=\"#{NaskEpp::EPP_SCHEMA_LOCATION}\">
  <command>
    <create>
      <domain:create
       xmlns:domain=\"#{NaskEpp::DOMAIN_SCHEMA}\"
       xsi:schemaLocation=\"#{NaskEpp::DOMAIN_SCHEMA_LOCATION}\">
        <domain:name>#{domain_params[:name]}</domain:name>" +
        (domain_params[:ns] ? domain_params[:ns].collect { |ns| "<domain:ns>#{ns}</domain:ns>" }.join : "") +
        domain_create_xml_without_book_params(_domain_params) +
        "<domain:authInfo>
          <domain:pw>#{domain_params[:pw]}</domain:pw>
        </domain:authInfo>
      </domain:create>
    </create>
    <extension>
      <extdom:create xmlns:extdom=\"#{NaskEpp::EXTDOM_SCHEMA}\"
       xsi:schemaLocation=\"#{NaskEpp::EXTDOM_SCHEMA_LOCATION}\">" +
        (_domain_params[:reason] ? "<extdom:reason>#{_domain_params[:reason]}</extdom:reason>" : "") +
        (domain_params[:book] ? "<extdom:book/>" : "") +
        (domain_params[:taste] ? "<extdom:taste/>" : "") +
      "</extdom:create>
    </extension>
    <clTRID>ABC-12345</clTRID>
  </command>
</epp>"
    end

    def domain_delete_xml(domain_name)
"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>
<epp xmlns=\"#{NaskEpp::EPP_SCHEMA}\"
xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
xsi:schemaLocation=\"#{NaskEpp::EPP_SCHEMA_LOCATION}\">
  <command>
    <delete>
      <domain:delete
      xmlns:domain=\"#{NaskEpp::DOMAIN_SCHEMA}\"
      xsi:schemaLocation=\"#{NaskEpp::DOMAIN_SCHEMA_LOCATION}\">
        <domain:name>#{domain_name}</domain:name>
      </domain:delete>
    </delete>
    <clTRID>ABC-12345</clTRID>
  </command>
</epp>"
    end

    def domain_remove_status_xml(domain_name, status_name)
"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>
<epp xmlns=\"urn:ietf:params:xml:ns:epp-1.0\"
xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
xsi:schemaLocation=\"urn:ietf:params:xml:ns:epp-1.0 epp-1.0.xsd\">
  <command>
    <update>
      <domain:update xmlns:domain=\"#{NaskEpp::DOMAIN_SCHEMA}\"
      xsi:schemaLocation=\"#{NaskEpp::DOMAIN_SCHEMA_LOCATION}\">
        <domain:name>#{domain_name}</domain:name>
        <domain:rem>
          <domain:status s=\"#{status_name}\"/>
        </domain:rem>
      </domain:update>
    </update>
    <clTRID>ABC-12345</clTRID>
  </command>
</epp>"
    end


    def domain_info_xml_authinfo(options)
      if options[:pw]
        "<domain:authInfo><domain:pw" +
        (options[:roid] ? " roid=\"#{options[:roid]}\"" : "") +
        ">#{options[:pw]}</domain:pw></domain:authInfo>"
      else "" end
    end

    def domain_info_xml(domain_name, options = {})
      _options = { :hosts => "all", :pw => nil, :roid => nil }
      _options.merge!(options)
"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>
<epp xmlns=\"#{NaskEpp::EPP_SCHEMA}\"
xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
xsi:schemaLocation=\"#{NaskEpp::EPP_SCHEMA_LOCATION}\">
  <command>
    <info>
      <domain:info xmlns:domain=\"#{NaskEpp::DOMAIN_SCHEMA}\"
      xsi:schemaLocation=\"#{NaskEpp::DOMAIN_SCHEMA_LOCATION}\">
        <domain:name hosts=\"#{_options[:hosts]}\">#{domain_name}</domain:name>" +
        domain_info_xml_authinfo(options) +
      "</domain:info>
    </info>
    <clTRID>ABC-12345</clTRID>
  </command>
</epp>"
    end

    def domain_check_xml(domains_names)
"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>
<epp xmlns=\"#{NaskEpp::EPP_SCHEMA}\"
     xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
     xsi:schemaLocation=\"#{NaskEpp::EPP_SCHEMA_LOCATION}\">
  <command>
    <check>
      <domain:check
       xmlns:domain=\"#{NaskEpp::DOMAIN_SCHEMA}\"
       xsi:schemaLocation=\"#{NaskEpp::DOMAIN_SCHEMA_LOCATION}\">" +
        domains_names.collect { |domain_name| "<domain:name>#{domain_name}</domain:name>" }.join +
      "</domain:check>
    </check>
    <clTRID>ABC-12345</clTRID>
  </command>
</epp>"
    end

    def domain_update_xml_add_params(domain_params)
      if domain_params[:ns_add] || domain_params[:client_update_prohibited] || domain_params[:client_renew_prohibited]
        "<domain:add>" +
        (domain_params[:ns_add] ? domain_params[:ns_add].collect { |ns| "<domain:ns>#{ns}</domain:ns>" }.join : "") +
        (domain_params[:client_update_prohibited] ? "<domain:status s=\"clientUpdateProhibited\"/>" : "") +
        (domain_params[:client_renew_prohibited] ? "<domain:status s=\"clientRenewProhibited\"/>" : "") +
        "</domain:add>"
      else "" end
    end

    def domain_update_xml_rem_params(domain_params)
      if domain_params[:ns_rem] || (domain_params[:client_update_prohibited] == false) || (domain_params[:client_renew_prohibited] == false)
        "<domain:rem>" +
        (domain_params[:ns_rem] ? domain_params[:ns_rem].collect { |ns| "<domain:ns>#{ns}</domain:ns>" }.join : "") +
        (domain_params[:client_update_prohibited] == false ? "<domain:status s=\"clientUpdateProhibited\"/>" : "") +
        (domain_params[:client_renew_prohibited] == false ? "<domain:status s=\"clientRenewProhibited\"/>" : "") +
        "</domain:rem>"
      else "" end
    end

    def domain_update_xml_change_params(domain_params)
      if domain_params[:pw]
        "<domain:chg>" +
        if domain_params[:pw]
          "<domain:authInfo>
            <domain:pw>#{domain_params[:pw]}</domain:pw>
          </domain:authInfo>"
        else "" end +
        "</domain:chg>"
      else "" end
    end

    def domain_update_xml(domain_name, domain_params)
"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>
<epp xmlns=\"#{NaskEpp::EPP_SCHEMA}\"
     xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
     xsi:schemaLocation=\"#{NaskEpp::EPP_SCHEMA_LOCATION}\">
  <command>
    <update>
      <domain:update
       xmlns:domain=\"#{NaskEpp::DOMAIN_SCHEMA}\"
       xsi:schemaLocation=\"#{NaskEpp::DOMAIN_SCHEMA_LOCATION}\">
        <domain:name>#{domain_name}</domain:name>" +
          domain_update_xml_add_params(domain_params) +
          domain_update_xml_rem_params(domain_params) +
          domain_update_xml_change_params(domain_params) +
      "</domain:update>
    </update>
    <clTRID>ABC-12345</clTRID>
  </command>
</epp>"
    end

    def domain_transfer_xml(domain_name, domain_params)
"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>
<epp xmlns=\"#{NaskEpp::EPP_SCHEMA}\"
     xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
     xsi:schemaLocation=\"#{NaskEpp::EPP_SCHEMA_LOCATION}\">
  <command>
    <transfer op=\"#{domain_params[:op]}\">
      <domain:transfer
       xmlns:domain=\"#{NaskEpp::DOMAIN_SCHEMA}\"
       xsi:schemaLocation=\"#{NaskEpp::DOMAIN_SCHEMA_LOCATION}\">
        <domain:name>#{domain_name}</domain:name>" +
        (domain_params[:period] ? "<domain:period unit=\"y\">#{domain_params[:period]}</domain:period>" : "") +
        "<domain:authInfo>
        <domain:pw" + (domain_params[:roid] ? " roid=\"#{domain_params[:roid]}\"" : "") + ">#{domain_params[:pw]}</domain:pw>
        </domain:authInfo>
      </domain:transfer>
    </transfer>
    <clTRID>ABC-12345</clTRID>
  </command>
</epp>"
    end

    def domain_renew_xml_extension(domain_params)
      if domain_params[:reactivate] || domain_params[:renew_to_date]
        "<extension>
           <extdom:renew
             xmlns:extdom=\"#{NaskEpp::EXTDOM_SCHEMA}\"
             xsi:schemaLocation=\"#{NaskEpp::EXTDOM_SCHEMA_LOCATION}\">" +
             (domain_params[:reactivate] ? "<extdom:reactivate/>" : "") +
             (domain_params[:renew_to_date] ? "<extdom:renewToDate>#{domain_params[:renew_to_date]}</domain:renewToDate>" : "") +
          "</extdom:renew></extension>"
      else "" end
    end

    def domain_renew_xml(domain_name, domain_params)
"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?> <epp xmlns=\"#{NaskEpp::EPP_SCHEMA}\"
xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"#{NaskEpp::EPP_SCHEMA_LOCATION}\">
  <command>
    <renew>
      <domain:renew
       xmlns:domain=\"#{NaskEpp::DOMAIN_SCHEMA}\"
       xsi:schemaLocation=\"#{NaskEpp::DOMAIN_SCHEMA_LOCATION}\">
        <domain:name>#{domain_name}</domain:name>
        <domain:curExpDate>#{domain_params[:cur_exp_date]}</domain:curExpDate>" +
        (domain_params[:period] ? "<domain:period unit=\"y\">#{domain_params[:period]}</domain:period>" : "") +
     "</domain:renew>
    </renew>" +
    domain_renew_xml_extension(domain_params) +
    "<clTRID>ABC-12345</clTRID>
  </command>
</epp>"
    end

end
