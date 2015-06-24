module NaskEpp::Host

  XMLNS = case NaskEpp_PROTOCOL_VERSION
  when "1.0"
    "urn:ietf:params:xml:ns:host-1.0"
  when "3.0"
    "http://www.dns.pl/nask-epp-schema/host-2.0"
  end

  def host_create(host_params)
    ["1000", "1001"].include?(request_element_attribute(host_create_xml(host_params), :result, :code))
  end

  def host_delete(host_name)
    request_element_attribute(host_delete_xml(host_name), :result, :code) == "1000"
  end

  def host_info(host_name, options = {})
    response_xml = request_xml(host_info_xml(host_name))
    if response_xml.search("result").first.attribute("code").value == "1000"
      {
        :name => host_info_extract(response_xml, :name),
        :addr => host_info_extract(response_xml, :addr),
        :status => host_status(response_xml)
      }
    end
  end

  def host_check(*host_names)
    response_xml = request_xml(host_check_xml(host_names))
    if response_xml.search("result").first.attribute("code").value == "1000"
      hosts_availability = {}
      host_names.each_with_index do |host_name, i|
        value = response_xml.xpath("//host:name[contains(text(), \"#{host_name}\")]", 'host' => XMLNS).first.attribute("avail").value == "true"
        hosts_availability["#{host_name}"] = value
      end
      hosts_availability.count == 1 ? hosts_availability.first.last : hosts_availability
    end
  end

  def host_change_addr(host_name, new_addr)
    request_element_attribute(host_change_addr_xml(host_name, host_addr(host_name), new_addr), :result, :code) == "1000"
  end

  def host_status_ok?(host_name)
    host_info(host_name)[:status] == "ok"
  rescue NoMethodError
    false
  end

  private

    def host_status(response_xml)
      response_xml.xpath("//host:status", 'host' => XMLNS).attribute("s").value
    end

    def host_addr(host_name)
      host_info(host_name)[:addr]
    rescue NoMethodError
      ""
    end

    def host_info_extract(response_xml, name)
      response_xml.xpath("//host:#{name}", 'host' => XMLNS).first.content
    rescue NoMethodError
      ""
    end

    def host_create_xml(host_params)
      my_host_params = {:ipv4 => [], :ipv6 => []}.merge(host_params)
"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>
<epp xmlns=\"#{NaskEpp::EPP_SCHEMA}\"
xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
xsi:schemaLocation=\"#{NaskEpp::EPP_SCHEMA_LOCATION}\">
  <command>
    <create>
      <host:create xmlns:host=\"#{NaskEpp::HOST_SCHEMA}\"
      xsi:schemaLocation=\"#{NaskEpp::HOST_SCHEMA_LOCATION}\">
        <host:name>#{my_host_params[:name]}</host:name>" +
        my_host_params[:ipv4].collect do |ipv4|
          "<host:addr ip=\"v4\">#{ipv4}</host:addr>"
        end.join +
        my_host_params[:ipv6].collect do |ipv6|
          "<host:addr ip=\"v6\">#{ipv6}</host:addr>"
        end.join +
      "</host:create>
    </create>
    <clTRID>ABC-12345</clTRID>
  </command>
</epp>"
    end

    def host_delete_xml(host_name)
"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>
<epp xmlns=\"#{NaskEpp::EPP_SCHEMA}\"
xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
xsi:schemaLocation=\"#{NaskEpp::EPP_SCHEMA_LOCATION}\">
  <command>
    <delete>
      <host:delete
      xmlns:host=\"#{NaskEpp::HOST_SCHEMA}\"
      xsi:schemaLocation=\"#{NaskEpp::HOST_SCHEMA_LOCATION}\">
      <host:name>#{host_name}</host:name> </host:delete>
    </delete>
    <clTRID>ABC-12345</clTRID>
  </command>
</epp>"
    end

    def host_info_xml(host_name)
"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>
<epp xmlns=\"#{NaskEpp::EPP_SCHEMA}\"
xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
xsi:schemaLocation=\"#{NaskEpp::EPP_SCHEMA_LOCATION}\">
  <command>
    <info>
      <host:info
      xmlns:host=\"#{NaskEpp::HOST_SCHEMA}\"
      xsi:schemaLocation=\"#{NaskEpp::HOST_SCHEMA_LOCATION}\">
        <host:name>#{host_name}</host:name> </host:info>
    </info>
    <clTRID>ABC-12345</clTRID>
  </command>
</epp>"
    end

    def host_check_xml(host_names)
"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?> <epp xmlns=\"#{NaskEpp::EPP_SCHEMA}\"
xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"#{NaskEpp::EPP_SCHEMA_LOCATION}\">
  <command>
    <check>
      <host:check xmlns:host=\"#{NaskEpp::HOST_SCHEMA}\"
      xsi:schemaLocation=\"#{NaskEpp::HOST_SCHEMA_LOCATION}\">" +
        host_names.collect { |host_name| "<host:name>#{host_name}</host:name>" }.join +
      "</host:check>
    </check>
    <clTRID>ABC-12345</clTRID>
  </command>
</epp>"
    end

    def host_change_addr_xml(host_name, old_addr, new_addr)
"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>
<epp xmlns=\"#{NaskEpp::EPP_SCHEMA}\"
xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
xsi:schemaLocation=\"#{NaskEpp::EPP_SCHEMA_LOCATION}\">
  <command>
    <update>
      <host:update xmlns:host=\"#{NaskEpp::HOST_SCHEMA}\"
      xsi:schemaLocation=\"#{NaskEpp::HOST_SCHEMA_LOCATION}\">
        <host:name>#{host_name}</host:name>
        <host:add>
          <host:addr ip=\"v4\">#{new_addr}</host:addr>
        </host:add>
        <host:rem>
          <host:addr ip=\"v4\">#{old_addr}</host:addr>
        </host:rem>
      </host:update>
    </update>
    <clTRID>ABC-12345</clTRID>
  </command>
</epp>"
    end

end
