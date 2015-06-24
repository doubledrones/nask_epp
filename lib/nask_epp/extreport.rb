module NaskEpp::Extreport

  XMLNS = case NaskEpp_PROTOCOL_VERSION
  when "1.0"
    "urn:ietf:params:xml:ns:extreport-1.0"
  when "3.0"
    "http://www.dns.pl/nask-epp-schema/extreport-2.0"
  end

  def extreport_domain(domain_params = {})
    response_xml = request_xml(extreport_domain_xml(domain_params))
    response_xml.xpath("//extreport:domData", 'extreport' => XMLNS).map do |domain_data|
      {
        :name => domain_data.xpath("//extreport:name", 'extreport' => XMLNS).first.content,
        :roid => domain_data.xpath("//extreport:roid", 'extreport' => XMLNS).first.content,
        :ex_date => domain_data.xpath("//extreport:exDate", 'extreport' => XMLNS).first.content,
        :statuses => domain_data.xpath("//extreport:status", 'extreport' => XMLNS).map(&:content)
      }
    end
  end

  def extreport_domain_count
    response_xml = request_xml(extreport_domain_xml({:limit => 1, :offset => 0}))
    response_xml.xpath("//extreport:size", 'extreport' => XMLNS).first.content.to_i
  end

  def extreport_contact(contact_params = {})
    response_xml = request_xml(extreport_contact_xml(contact_params))
    response_xml.xpath("//extreport:conId", 'extreport' => XMLNS).map(&:content)
  end

  def extreport_contact_count
    response_xml = request_xml(extreport_contact_xml({:limit => 1, :offset => 0}))
    response_xml.xpath("//extreport:size", 'extreport' => XMLNS).first.content.to_i
  end

  def extreport_host(host_params = {})
    response_xml = request_xml(extreport_host_xml(host_params))
    response_xml.xpath("//extreport:name", 'extreport' => XMLNS).map(&:content)
  end

  def extreport_host_count
    response_xml = request_xml(extreport_host_xml({:limit => 1, :offset => 0}))
    response_xml.xpath("//extreport:size", 'extreport' => XMLNS).first.content.to_i
  end

  private

    def extreport_domain_xml(domain_params = {})
      _domain_params = {
        :state => "STATE_REGISTERED",
        :offset => 0,
        :limit => 50,
        :statuses_in => false
      }
      _domain_params.merge!(domain_params)
"<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<epp xmlns=\"#{NaskEpp::EPP_SCHEMA}\"
xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
xsi:schemaLocation=\"#{NaskEpp::EPP_SCHEMA_LOCATION}\">
  <extension>
    <extreport:report
    xmlns:extreport=\"#{NaskEpp::EXTREPORT_SCHEMA}\"
    xsi:schemaLocation=\"#{NaskEpp::EXTREPORT_SCHEMA_LOCATION}\">
      <extreport:domain>
        <extreport:state>#{_domain_params[:state]}</extreport:state>
#{extreport_xml_timestamp(_domain_params)}
#{extreport_xml_statuses_in(_domain_params)}
      </extreport:domain>
#{extreport_navigation_xml(_domain_params)}
    </extreport:report>
  </extension>
</epp>"
    end

    def extreport_contact_xml(contact_params = {})
      _contact_params = {
        :id => nil,
        :offset => 0,
        :limit => 50
      }
      _contact_params.merge!(contact_params)
"<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<epp xmlns=\"#{NaskEpp::EPP_SCHEMA}\"
xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
xsi:schemaLocation=\"#{NaskEpp::EPP_SCHEMA_LOCATION}\">
  <extension>
    <extreport:report
    xmlns:extreport=\"#{NaskEpp::EXTREPORT_SCHEMA}\"
    xsi:schemaLocation=\"#{NaskEpp::EXTREPORT_SCHEMA_LOCATION}\">
#{extreport_contact_xml_id(_contact_params)}
#{extreport_navigation_xml(_contact_params)}
    </extreport:report>
  </extension>
</epp>"
    end

    def extreport_host_xml(host_params = {})
      _host_params = {
        :name => nil,
        :offset => 0,
        :limit => 50
      }
      _host_params.merge!(host_params)
"<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<epp xmlns=\"#{NaskEpp::EPP_SCHEMA}\"
xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
xsi:schemaLocation=\"#{NaskEpp::EPP_SCHEMA_LOCATION}\">
  <extension>
    <extreport:report
    xmlns:extreport=\"#{NaskEpp::EXTREPORT_SCHEMA}\"
    xsi:schemaLocation=\"#{NaskEpp::EXTREPORT_SCHEMA_LOCATION}\">
#{extreport_host_xml_id(_host_params)}
#{extreport_navigation_xml(_host_params)}
    </extreport:report>
  </extension>
</epp>"
    end

    def extreport_host_xml_id(host_params = {})
      if host_params[:name]
        "<extreport:host>
          <extreport:name>#{host_params[:name]}</extreport:name>
        </extreport:host>"
      else
        "<extreport:host/>"
      end
    end

    def extreport_contact_xml_id(contact_params = {})
      if contact_params[:id]
        "<extreport:contact>
          <extreport:conId>#{@prefix}#{contact_params[:id]}</extreport:conId>
        </extreport:contact>"
      else
        "<extreport:contact/>"
      end
    end

    def extreport_xml_timestamp(domain_params = {})
      if domain_params[:expiration_timestamp]
        day = domain_params[:expiration_timestamp].strftime("%Y-%m-%d")
        hour = domain_params[:expiration_timestamp].strftime("%H:%M")
        "<extreport:exDate>#{day}T#{hour}:00.0Z</extreport:exDate>"
      end
    end

    def extreport_xml_statuses_in(domain_params = {})
      if domain_params[:statuses_in]
        "<extreport:statuses statusesIn=\"true\">
          <extreport:status>serverHold</extreport:status>
        </extreport:statuses>"
      end
    end

    def extreport_navigation_xml(params = {})
      _params = {:offset => 0, :limit => 50}
      _params.merge!(params)
      "<extreport:offset>#{_params[:offset]}</extreport:offset>"+
      "<extreport:limit>#{_params[:limit]}</extreport:limit>"
    end

end
