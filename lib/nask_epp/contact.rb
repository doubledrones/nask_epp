module NaskEpp::Contact

  case NaskEpp_PROTOCOL_VERSION
  when "1.0"
    XMLNS = "urn:ietf:params:xml:ns:contact-1.0"
    EXTCON_XMLNS = "http://www.dns.pl/NASK-EPP/extcon-1.0"
  when "3.0"
    XMLNS = "http://www.dns.pl/nask-epp-schema/contact-2.0"
    EXTCON_XMLNS = "http://www.dns.pl/nask-epp-schema/extcon-2.0"
  end

  def contact_check(*contacts_ids)
    response_xml = request_xml(contact_check_xml(contacts_ids))
    if response_xml.search("result").first.attribute("code").value == "1000"
      contacts_availability = {}
      contacts_ids.each_with_index do |contact_id, i|
        avail = response_xml.xpath("//contact:id[contains(text(), \"#{contact_id}\")]", 'contact' => XMLNS).first.attribute("avail").value
        contacts_availability[contact_id] = (avail == "true")
      end
      contacts_availability
    end
  end

  class ContactNotCreated < StandardError
  end

  def contact_create(credentials)
    contact_create!(credentials)
  rescue ContactNotCreated
    false
  end

  def contact_create!(credentials)
    response_xml = request_xml(contact_create_xml(credentials))
    if response_xml.search("result").first.attribute("code").value == "1000"
      true
    else
      raise ContactNotCreated, response_error(response_xml)
    end
  end

  def contact_delete(contact_id)
    request_element_attribute(contact_delete_xml(contact_id), :result, :code) == "1000"
  end

  def contact_info(contact_id, options = {})
    response_xml = request_xml(contact_info_xml(contact_id, options))
    if response_xml.search("result").first.attribute("code").value == "1000"
      {
        :contact_id => contact_info_extract(response_xml, :id).gsub(/[a-z]/, "").to_i,
        :name => contact_info_extract(response_xml, :name),
        :street => contact_info_extract(response_xml, :street),
        :city => contact_info_extract(response_xml, :city),
        :province => contact_info_extract(response_xml, :sp),
        :zip_code => contact_info_extract(response_xml, :pc),
        :country => contact_info_extract(response_xml, :cc),
        :phone => contact_info_extract(response_xml, :voice),
        :fax => contact_info_extract(response_xml, :fax),
        :email => contact_info_extract(response_xml, :email),
        :publish => contact_info_extract(response_xml, :publish),
        :person => contact_info_extract(response_xml, :person)
      }
    end
  end

  class ContactNotUpdated < StandardError
  end

  def contact_update(contact_id, params)
    contact_update!(contact_id, params)
  rescue ContactNotUpdated
    false
  end

  def contact_update!(contact_id, params)
    response_xml = request_xml(contact_update_xml(contact_id, params))
    if response_xml.search("result").first.attribute("code").value == "1000"
      true
    else
      raise ContactNotUpdated, response_error(response_xml)
    end
  end

  def contacts
    contact_count = extreport_contact_count
    offset = 0
    limit = 1000
    position = offset
    _contacts = []
    while position <= contact_count
      _contacts += extreport_contact(:offset => position, :limit => limit)
      position += limit
      sleep 5 if position < contact_count
    end
    _contacts.map { |contact| contact.gsub(@prefix, '') }
  end

  private

    def contact_info_extract_decode_name(name)
      case name
      when :publish then "consentForPublishing"
      when :person then "individual"
      end
    end

    def contact_info_extract(response_xml, name)
      if name == :publish || name == :person
        value = response_xml.xpath("//extcon:#{contact_info_extract_decode_name(name)}", 'extcon' => EXTCON_XMLNS).first.content
        value == "1" || value == "true"
      else
        response_xml.xpath("//contact:#{name}", 'contact' => XMLNS).first.content
      end
    rescue NoMethodError
      ""
    end

    def contact_check_xml(contacts_ids)
"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>
<epp xmlns=\"#{NaskEpp::EPP_SCHEMA}\"
     xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
     xsi:schemaLocation=\"#{NaskEpp::EPP_SCHEMA_LOCATION}\">
    <command>
      <check>
        <contact:check
         xmlns:contact=\"#{NaskEpp::CONTACT_SCHEMA}\"
         xsi:schemaLocation=\"#{NaskEpp::CONTACT_SCHEMA_LOCATION}\">" +
           contacts_ids.collect { |contact_id| "<contact:id>#{@prefix}#{contact_id}</contact:id>" }.join +
"        </contact:check>
      </check>
      <clTRID>ABC-12345</clTRID>
    </command>
  </epp>"
    end

    def contact_create_xml(credentials)
      unless "#{credentials[:contact_id]}" =~ /^[0-9]+$/
        raise "Contact ID must be numeric (was: #{credentials[:contact_id]})"
      end
      the_credentials = credentials.dup
      the_credentials[:contact_id] = @prefix + "#{the_credentials[:contact_id]}"
      credentials = NaskEpp::ContactCredentials.new(the_credentials).to_hash
"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>
<epp xmlns=\"#{NaskEpp::EPP_SCHEMA}\"
     xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
     xsi:schemaLocation=\"#{NaskEpp::EPP_SCHEMA_LOCATION}\">
  <command>
    <create>
      <contact:create
       xmlns:contact=\"#{NaskEpp::CONTACT_SCHEMA}\"
       xsi:schemaLocation=\"#{NaskEpp::CONTACT_SCHEMA_LOCATION}\">
        <contact:id>#{credentials[:contact_id]}</contact:id>
        <contact:postalInfo type=\"loc\">
          <contact:name>#{credentials[:name]}</contact:name>" +
          (credentials[:org] ? "<contact:org>#{credentials[:org]}</contact:org>" : "") +
          "<contact:addr>
            <contact:street>#{credentials[:street]}</contact:street>
            <contact:city>#{credentials[:city]}</contact:city>
            <contact:sp>#{credentials[:province]}</contact:sp>
            <contact:pc>#{credentials[:zip_code]}</contact:pc>
            <contact:cc>#{credentials[:country]}</contact:cc>
          </contact:addr>
        </contact:postalInfo>
        <contact:voice x=\"1234\">#{credentials[:phone]}</contact:voice>
        <contact:fax>#{credentials[:fax]}</contact:fax>
        <contact:email>#{credentials[:email]}</contact:email>
        <contact:authInfo>
          <contact:pw>contacssst-6c01-#{credentials[:contact_id]}</contact:pw>
        </contact:authInfo>
      </contact:create>
    </create>
      <extension>
       <extcon:create xmlns:extcon=\"#{NaskEpp::EXTCON_SCHEMA}\"
            xsi:schemaLocation=\"#{NaskEpp::EXTCON_SCHEMA_LOCATION}\">
          <extcon:individual>#{credentials[:person] ? "1" : "0"}</extcon:individual>
          <extcon:consentForPublishing>#{credentials[:publish] ? "1" : "0"}</extcon:consentForPublishing>
        </extcon:create>
      </extension>
    <clTRID>ABC-12345</clTRID>
  </command>
</epp>"
    end

    def contact_delete_xml(contact_id)
"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>
<epp xmlns=\"#{NaskEpp::EPP_SCHEMA}\"
     xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
     xsi:schemaLocation=\"#{NaskEpp::EPP_SCHEMA_LOCATION}\">
  <command>
    <delete>
      <contact:delete
       xmlns:contact=\"#{NaskEpp::CONTACT_SCHEMA}\"
       xsi:schemaLocation=\"#{NaskEpp::CONTACT_SCHEMA_LOCATION}\">
        <contact:id>#{@prefix}#{contact_id}</contact:id>
      </contact:delete>
    </delete>
<clTRID>ABC-12345</clTRID>
  </command>
</epp>"
    end

    def contact_info_xml(contact_id, options = {})
      my_options = { :prefix => @prefix, :pw => nil }
      my_options.merge!(options)
      "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?> <epp xmlns=\"#{NaskEpp::EPP_SCHEMA}\"
xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"#{NaskEpp::EPP_SCHEMA_LOCATION}\">
  <command>
    <info>
<contact:info xmlns:contact=\"#{NaskEpp::CONTACT_SCHEMA}\" xsi:schemaLocation=\"#{NaskEpp::CONTACT_SCHEMA_LOCATION}\">
        <contact:id>#{my_options[:prefix]}#{contact_id}</contact:id>
      </contact:info>
    </info>" + (my_options[:pw].nil? ? "" : "<extension>
<extcon:info xmlns:extcon=\"#{NaskEpp::EXTCON_SCHEMA}\" xsi:schemaLocation=\"#{NaskEpp::EXTCON_SCHEMA_LOCATION}\">
              <extcon:authInfo>
                <extcon:pw" + (my_options[:roid].nil? ? "" : " roid=\"#{my_options[:roid]}\"") + ">#{my_options[:pw]}</extcon:pw>
              </extcon:authInfo>
          </extcon:info>
      </extension>") + "<clTRID>ABC-12345</clTRID>
  </command>
</epp>"
    end
    def contact_update_xml_change_address?(params)
      params[:street] && params[:city] && params[:country]
    end

    def contact_update_xml_change_postal_info_params?(params)
      contact_update_xml_change_address?(params) || params[:name] || params[:org]
    end

    def contact_update_xml_postal_info_params(params)
      _params = {:type => "loc"}
      _params.merge!(params)
      if contact_update_xml_change_postal_info_params?(params)
        "<contact:postalInfo type=\"#{_params[:type]}\">" +
          (params[:name] ? "<contact:name>#{params[:name]}</contact:name>" : "") +
          (params[:org] ? "<contact:org>#{params[:org]}</contact:org>" : "") +
          if contact_update_xml_change_address?(params)
            "<contact:addr>
              <contact:street>#{params[:street]}</contact:street>
              <contact:city>#{params[:city]}</contact:city>
              <contact:cc>#{params[:country]}</contact:cc>" +
              (params[:province] ? "<contact:sp>#{params[:province]}</contact:sp>" : "") +
              (params[:zip_code] ? "<contact:pc>#{params[:zip_code]}</contact:pc>" : "") +
            "</contact:addr>"
          else "" end +
        "</contact:postalInfo>"
      else "" end
    end

    def contact_update_xml_extension(params)
      if !(params[:publish].nil? || params[:person].nil?)
        "<extension>
           <extcon:update xmlns:extcon=\"#{NaskEpp::EXTCON_SCHEMA}\"
            xsi:schemaLocation=\"#{NaskEpp::EXTCON_SCHEMA_LOCATION}\">" +
             (params[:person].nil? ? "" : "<extcon:individual>#{params[:person] ? "1" : "0"}</extcon:individual>") +
             (params[:publish].nil? ? "" :  "<extcon:consentForPublishing>#{params[:publish] ? "1" : "0"}</extcon:consentForPublishing>") +
           "</extcon:update>
         </extension>"
      else "" end
    end

    def contact_update_xml_change_params?(params)
      contact_update_xml_change_postal_info_params?(params) || params[:phone] || params[:fax] || params[:email] || params[:pw]
    end

    def contact_update_xml_change_params(params)
      if contact_update_xml_change_params?(params)
        "<contact:chg>" +
          contact_update_xml_postal_info_params(params) +
          (params[:phone].nil? ? "" : "<contact:voice>#{params[:phone]}</contact:voice>") +
          (params[:fax].nil? ? "" : "<contact:fax>#{params[:fax]}</contact:fax>") +
          (params[:email].nil? ? "" : "<contact:email>#{params[:email]}</contact:email>") +
          (params[:pw].nil? ? "" : "<contact:authInfo><contact:pw>#{params[:pw]}</contact:pw></contact:authInfo>") +
        "</contact:chg>"
      else "" end
    end

    def contact_update_xml(contact_id, params)
"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>
<epp xmlns=\"#{NaskEpp::EPP_SCHEMA}\"
     xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
     xsi:schemaLocation=\"#{NaskEpp::EPP_SCHEMA_LOCATION}\">
  <command>
    <update>
      <contact:update
       xmlns:contact=\"#{NaskEpp::CONTACT_SCHEMA}\"
       xsi:schemaLocation=\"#{NaskEpp::CONTACT_SCHEMA_LOCATION}\">
        <contact:id>#{@prefix}#{contact_id}</contact:id>" +
        contact_update_xml_change_params(params) +
      "</contact:update>
    </update>" +
    contact_update_xml_extension(params) +
  "</command>
</epp>"
    end

end
