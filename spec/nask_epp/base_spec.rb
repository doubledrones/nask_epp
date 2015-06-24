require 'spec_helper'

describe NaskEpp::Base, :vcr do

  include_context "accounts"

  let(:the_class) { Nask }
  let(:the_object) { the_class.new(login, password, prefix) }

  subject { the_object }

  describe "first account" do
    let(:login)    { login1 }
    let(:password) { password1 }
    let(:prefix)   { prefix1 }

    its(:cert) { should be_instance_of OpenSSL::X509::Certificate }

    its(:key) { should be_instance_of OpenSSL::PKey::RSA }

    its(:https) { should be_instance_of Net::HTTP }
  end

  describe "second account" do
    let(:login)    { login2 }
    let(:password) { password2 }
    let(:prefix)   { prefix2 }

    its(:cert) { should be_instance_of OpenSSL::X509::Certificate }

    its(:key) { should be_instance_of OpenSSL::PKey::RSA }

    its(:https) { should be_instance_of Net::HTTP }
  end

end
