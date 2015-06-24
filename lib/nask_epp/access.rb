module NaskEpp::Access

  def hello
    request_element_content(hello_xml, :svID) == "NASK EPP Registry"
  end

  def login(user, password)
    request_element_attribute(login_xml(user, password), :result, :code) == "1000"
  end

  def change_password(user, password, new_password)
    request_element_attribute(change_password_xml(user, password, new_password), :result, :code) == "1000"
  end

  def logout
    request_element_attribute(logout_xml, :result, :code) == "1500"
  end

  private

    def hello_xml
"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>
<epp xmlns=\"#{NaskEpp::EPP_SCHEMA}\"
     xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
     xsi:schemaLocation=\"#{NaskEpp::EPP_SCHEMA_LOCATION}\">
  <hello/>
</epp>"
    end

    def login_xml(login, password)
"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>
<epp xmlns=\"#{NaskEpp::EPP_SCHEMA}\"
     xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
     xsi:schemaLocation=\"#{NaskEpp::EPP_SCHEMA_LOCATION}\">
  <command>
    <login>
      <clID>#{login}</clID>
      <pw>#{password}</pw>
      <options>
        <version>1.0</version>
        <lang>en</lang>
      </options>
      <svcs>
        <objURI>#{NaskEpp::CONTACT_SCHEMA}</objURI>
        <objURI>#{NaskEpp::HOST_SCHEMA}</objURI>
        <objURI>#{NaskEpp::DOMAIN_SCHEMA}</objURI>
        <svcExtension>
          <extURI>#{NaskEpp::EXTCON_SCHEMA}</extURI>
          <extURI>#{NaskEpp::EXTDOM_SCHEMA}</extURI>
        </svcExtension>
      </svcs>
    </login>
    <clTRID>ABC-12345</clTRID>
  </command>
</epp>"
    end

    def change_password_xml(user, password, new_password)
"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>
<epp xmlns=\"#{NaskEpp::EPP_SCHEMA}\"
     xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
     xsi:schemaLocation=\"#{NaskEpp::EPP_SCHEMA_LOCATION}\">
  <command>
    <login>
      <clID>#{user}</clID>
      <pw>#{password}</pw>
      <newPW>#{new_password}</newPW>
      <options>
        <version>1.0</version>
        <lang>pl</lang>
      </options>
      <svcs>
        <objURI>#{NaskEpp::CONTACT_SCHEMA}</objURI>
        <objURI>#{NaskEpp::HOST_SCHEMA}</objURI>
        <objURI>#{NaskEpp::DOMAIN_SCHEMA}</objURI>
        <svcExtension>
          <extURI>#{NaskEpp::EXTCON_SCHEMA}</extURI>
          <extURI>#{NaskEpp::EXTDOM_SCHEMA}</extURI>
        </svcExtension>
      </svcs>
    </login>
    <clTRID>ABC-12345</clTRID>
  </command>
</epp>"
    end

    def logout_xml
"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>
<epp xmlns=\"#{NaskEpp::EPP_SCHEMA}\"
     xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
     xsi:schemaLocation=\"#{NaskEpp::EPP_SCHEMA_LOCATION}\">
<command>
<logout/>
<clTRID>ABC-12345</clTRID>
</command>
</epp>"
    end
end
