require 'net/http'
require 'net/https'
require 'nokogiri'

module NaskEpp::Base

  private

    def cert
      @certifiate ||= OpenSSL::X509::Certificate.new(File.open(NaskEpp::CERT))
    end

    def key
      @key ||= OpenSSL::PKey::RSA.new(File.open(NaskEpp::KEY))
    end

    def https
      unless @https
        @https = Net::HTTP.new(NaskEpp::SERVER, 443)
        @https.cert = cert
        @https.key = key
        @https.ca_file = NaskEpp::CA_FILE
        @https.verify_mode = OpenSSL::SSL::VERIFY_PEER
        @https.verify_depth = 5
        @https.use_ssl = true
        @https.set_debug_output $stderr if @debug
      end
      @https
    end

    def request_raw(xml)
      r = Net::HTTP::Post.new(NaskEpp::PATH)
      r.body = xml
      r.basic_auth(@user, @password)
      r['Cookie'] = @cookie if @cookie
      response = https.request(r)
      @cookie ||= response.response['Set-Cookie'].split('; ')[0]
      response
    end

    def request(xml)
      request_raw(xml).body
    end

    def request_xml(xml)
      puts xml if @debug
      a = Nokogiri::XML(request(xml))
      puts a if @debug
      a
    end

    def request_element(xml, element)
      request_xml(xml).search(element.to_s).first
    end

    def request_element_content(xml, element)
      request_element(xml, element).content
    end

    def request_element_attribute(xml, element, attribute)
      request_element(xml, element).attribute(attribute.to_s).value
    end

    def response_error_reason_given?(result_code)
      !%w(2303 2002 2005).include?(result_code)
    end

    def response_result_code(xml)
      xml.search("result").first.attribute("code").value
    end

    def response_error_reason(xml)
      response_error_reason_given?(response_result_code(xml)) ? "\nReason: #{xml.search("reason").first.content}" : ""
    end

    def response_error(xml)
      "#{xml}"
      #"Result code: " + response_result_code(xml) + response_error_reason(xml)
    end

end
