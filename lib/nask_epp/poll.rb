module NaskEpp::Poll

  def poll_req
    response_xml = request_xml(poll_xml("req", nil))
    if response_xml.search("result").first.attribute("code").value == "1301"
      { :msg_id => response_xml.search("msgQ").attribute("id").value.to_i,
        :msg => response_xml.search("msg").last.content }
    end
  end

  def poll_ack(msg_id)
    request_element_attribute(poll_xml("ack", msg_id), :result, :code) == "1000"
  end

  private

    def poll_xml(op, msg_id)
"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?> <epp xmlns=\"#{NaskEpp::EPP_SCHEMA}\"
xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"#{NaskEpp::EPP_SCHEMA_LOCATION}\">
    <command>
      <poll op=\"#{op}\"#{" msgID=\"#{msg_id}\" " if op == "ack"}/>
      <clTRID>ABC-12345</clTRID>
    </command>
</epp>"
    end

end
