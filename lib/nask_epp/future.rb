module NaskEpp::Future

  XMLNS = case NaskEpp_PROTOCOL_VERSION
  when "1.0"
    "http://www.dns.pl/NASK-EPP/future-1.0"
  when "3.0"
    "http://www.dns.pl/nask-epp-schema/future-2.0"
  end

  def future_create(future_params)
    request_element_attribute(future_create_xml(future_params), :result, :code) == "1000"
  end

  def future_transfer(future_name, future_params)
    request_element_attribute(future_transfer_xml(future_name, future_params), :result, :code) =~ /1000|1001/
  end

  def future_check(*futures_names)
    response_xml = request_xml(future_check_xml(futures_names))
    if response_xml.search("result").first.attribute("code").value == "1000"
      futures_availability = {}
      futures_names.each do |future_name|
        futures_availability["#{future_name}"] = response_xml.xpath("//future:name[contains(text(), \"#{future_name}\")]", 'future' => XMLNS).first.attribute("avail").value
      end
      futures_availability
    end
  end

  def future_info(future_name, options = {})
    response_xml = request_xml(future_info_xml(future_name, options))
    if response_xml.search("result").first.attribute("code").value == "1000"
      {
        :name => future_info_extract(response_xml, :name),
        :roid => future_info_extract(response_xml, :roid),
        :registrant => future_info_extract(response_xml, :registrant),
        :clID => future_info_extract(response_xml, :clID),
        :crID => future_info_extract(response_xml, :crID),
        :crDat => future_info_extract(response_xml, :crDat),
        :exDate => future_info_extract(response_xml, :exDate),
        :upID => future_info_extract(response_xml, :upID),
        :upDate => future_info_extract(response_xml, :upDate),
        :trDate => future_info_extract(response_xml, :trDate),
        :pw => future_info_extract(response_xml, :pw)
      }
    end
  end

  def future_renew(future_name, future_params)
    request_element_attribute(future_renew_xml(future_name, future_params), :result, :code) == "1000"
  end

  def future_delete(future_name)
    request_element_attribute(future_delete_xml(future_name), :result, :code) == "1000"
  end

  def future_update(future_name, future_params)
    request_element_attribute(future_update_xml(future_name, future_params), :result, :code) == "1000"
  end

  private

    def future_info_extract(response_xml, name)
      response_xml.xpath("//future:#{name}", 'future' => XMLNS).first.content
    rescue NoMethodError
      ""
    end

    def future_create_xml(future_params)
"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>
<epp xmlns=\"#{NaskEpp::EPP_SCHEMA}\"
     xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
     xsi:schemaLocation=\"#{NaskEpp::EPP_SCHEMA_LOCATION}\">
  <command>
    <create>
      <future:create
       xmlns:future=\"#{NaskEpp::FUTURE_SCHEMA}\"
       xsi:schemaLocation=\"#{NaskEpp::FUTURE_SCHEMA_LOCATION}\">
        <future:name>#{future_params[:name]}</future:name>
        <future:period unit=\"y\">#{future_params[:period]}</future:period>
        <future:registrant>#{future_params[:registrant]}</future:registrant>
         <future:authInfo>
           <future:pw>#{future_params[:pw]}</future:pw>
         </future:authInfo>
       </future:create>
    </create>
       <clTRID>ABC-12345</clTRID>
  </command>
</epp>"
    end

    #TODO add - opcjonalny element <extfut:resendConfirmationRequest> (bez wartości).
    def future_transfer_xml(future_name, future_params)
"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?> <epp xmlns=\"#{NaskEpp::EPP_SCHEMA}\"
xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"#{NaskEpp::EPP_SCHEMA_LOCATION}\">
  <command>
    <transfer op=\"#{future_params[:op]}\">
      <future:transfer
      xmlns:future=\"#{NaskEpp::FUTURE_SCHEMA}\" xsi:schemaLocation=\"#{NaskEpp::FUTURE_SCHEMA_LOCATION}\">
<future:name>#{future_name}</future:name> <future:authInfo>
          <future:pw" + (future_params[:roid] ? future_params[:roid] : "") + ">#{future_params[:pw]}</future:pw>
        </future:authInfo>
      </future:transfer>
    </transfer>
    <clTRID>ABC-12345</clTRID>
  </command>
</epp>"
    end

    def future_check_xml(futures_names)
"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>
<epp xmlns=\"#{NaskEpp::EPP_SCHEMA}\"
     xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
     xsi:schemaLocation=\"#{NaskEpp::EPP_SCHEMA_LOCATION}\">
  <command>
    <check>
      <future:check
       xmlns:future=\"#{NaskEpp::FUTURE_SCHEMA}\"
       xsi:schemaLocation=\"#{NaskEpp::FUTURE_SCHEMA_LOCATION}\">" +
        futures_names.collect { |future_name| "<future:name>#{future_name}</future:name>" }.join +
      "</future:check>
    </check>
<clTRID>ABC-12345</clTRID>
  </command>
</epp>"
    end

    def future_info_xml_authinfo(options = {})
      if options[:pw]
        "<future:authInfo><future:pw" +
        (options[:roid] ? " roid=\"#{options[:roid]}\"" : "") +
        ">#{options[:pw]}</future:pw></future:authInfo>"
      else "" end
    end

    def future_info_xml(future_name, options = {})
"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>
<epp xmlns=\"#{NaskEpp::EPP_SCHEMA}\"
xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"#{NaskEpp::EPP_SCHEMA_LOCATION}\">
  <command>
    <info>
<future:info xmlns:future=\"#{NaskEpp::FUTURE_SCHEMA}\" xsi:schemaLocation=\"#{NaskEpp::FUTURE_SCHEMA_LOCATION}\">
<future:name>#{future_name}</future:name>" +
        future_info_xml_authinfo(options) +
      "</future:info>
    </info>
    <clTRID>ABC-12345</clTRID>
  </command>
</epp>"
    end

    def future_renew_xml(future_name, future_params)
"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?> <epp xmlns=\"#{NaskEpp::EPP_SCHEMA}\"
xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"#{NaskEpp::EPP_SCHEMA_LOCATION}\">
  <command>
    <renew>
<future:renew xmlns:future=\"#{NaskEpp::FUTURE_SCHEMA}\" xsi:schemaLocation=\"#{NaskEpp::FUTURE_SCHEMA_LOCATION}\">
<future:name>#{future_name}</future:name> <future:curExpDate>#{future_params[:cur_exp_date]}</future:curExpDate> <future:period unit=\"y\">#{future_params[:period]}</future:period>
      </future:renew>
    </renew>
    <clTRID>ABC-12345</clTRID>
  </command>
</epp>"
    end

    def future_delete_xml(future_name)
"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?> <epp xmlns=\"#{NaskEpp::EPP_SCHEMA}\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"#{NaskEpp::EPP_SCHEMA_LOCATION}\">
   <command>
      <delete>
<future:delete xmlns:future=\"#{NaskEpp::FUTURE_SCHEMA}\" xsi:schemaLocation=\"#{NaskEpp::FUTURE_SCHEMA_LOCATION}\">
<future:name>#{future_name}</future:name> </future:delete>
</delete>
      <clTRID>ABC-12345</clTRID>
   </command>
</epp>"
    end

    def future_update_xml_change_params(future_params)
      "<future:chg>" + (future_params[:registrant] ? "<future:registrant>#{future_params[:registrant]}</future:registrant>" : "") +
      (future_params[:pw] ? "<future:authInfo><future:pw>#{future_params[:pw]}</future:pw></future:authInfo>" : "") + "</future:chg>"
    end

    def future_update_xml(future_name, future_params)
"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?> <epp xmlns=\"#{NaskEpp::EPP_SCHEMA}\"
xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"#{NaskEpp::EPP_SCHEMA_LOCATION}\">
  <command>
    <update>
      <future:update xmlns:future=\"#{NaskEpp::FUTURE_SCHEMA}\" xsi:schemaLocation=\"#{NaskEpp::FUTURE_SCHEMA_LOCATION}\">
        <future:name>#{future_name}</future:name>" +
        future_update_xml_change_params(future_params) +
      "</future:update>
      </update>
    <clTRID>ABC-12345</clTRID>
  </command>
</epp>"
    end

end
