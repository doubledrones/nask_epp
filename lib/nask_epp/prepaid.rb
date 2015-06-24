module NaskEpp::Prepaid

  XMLNS = case NaskEpp_PROTOCOL_VERSION
  when "1.0"
    "urn:ietf:params:xml:ns:extreport-1.0"
  when "3.0"
    "http://www.dns.pl/nask-epp-schema/extreport-2.0"
  end

  def prepaid_payment_funds(account_type)
    response_xml = request_xml(prepaid_payment_funds_xml(account_type))
    if response_xml.search("result").first.attribute("code").value == "1000"
      response_xml.xpath("//extreport:currentBalance", "extreport" => XMLNS).first.content.to_i
    end
  end

  private

    def prepaid_payment_funds_xml(account_type)
"<?xml version=\"1.0\" encoding=\"UTF-8\"?>
  <epp xmlns=\"#{NaskEpp::EPP_SCHEMA}\"
  xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"#{NaskEpp::EPP_SCHEMA_LOCATION}\"> <extension>
  <extreport:report
  xmlns:extreport=\"#{NaskEpp::EXTREPORT_SCHEMA}\" xsi:schemaLocation=\"#{NaskEpp::EXTREPORT_SCHEMA_LOCATION}\">
                    <extreport:prepaid>
                          <extreport:paymentFunds>
  <extreport:accountType>#{account_type}</extreport:accountType>
                          </extreport:paymentFunds>
                    </extreport:prepaid>
  <extreport:offset>0</extreport:offset>
  <extreport:limit>50</extreport:limit> </extreport:report>
        </extension>
</epp>"
    end

end
