# coding: utf-8

require 'spec_helper'

describe NaskEpp::ContactCredentials, :vcr do

  include_context "accounts"
  include_context "contacts"

  let(:the_class) { NaskEpp::ContactCredentials }
  let(:the_object) { the_class.new(contact_data) }
  subject { the_object }

  let(:contact_id) { "prostydns_00111" }

  context "when credentials valid" do
    its(:to_hash) { should == contact_data }
  end

  context "when contact_id contains forbidden characters" do
    let(:contact_id) { "prostydns-00111" }

    it {
      expect {
        subject.to_hash
      }.to raise_error(NaskEpp::ContactCredentials::Error)
    }
  end

  context "when contact_id less than 3 characters" do
    let(:contact_id) { "p1" }

    it {
      expect {
        subject.to_hash
      }.to raise_error(NaskEpp::ContactCredentials::Error)
    }
  end

  context "when contact_id more than 15 characters" do
    let(:contact_id) { "prostydns_001111" }

    it {
      expect {
        subject.to_hash
      }.to raise_error(NaskEpp::ContactCredentials::Error)
    }
  end

  context "when name contains forbidden character" do
    let(:name) { "Kuku < La" }

    it {
      expect {
        subject.to_hash
      }.to raise_error(NaskEpp::ContactCredentials::Error)
    }
  end

  context "when street contains forbidden character" do
    let(:street) { "Kaka >" }

    it {
      expect {
        subject.to_hash
      }.to raise_error(NaskEpp::ContactCredentials::Error)
    }
  end

  context "when city contains forbidden character" do
    let(:city) { "| Gugu" }

    it {
      expect {
        subject.to_hash
      }.to raise_error(NaskEpp::ContactCredentials::Error)
    }
  end

  context "when province contains forbidden character" do
    let(:province) { "Fugu [" }

    it {
      expect {
        subject.to_hash
      }.to raise_error(NaskEpp::ContactCredentials::Error)
    }
  end

  context "when zip_code contains forbidden character" do
    let(:zip_code) { "#{ENV['CONTACT1_ZIP_CODE']}]" }

    it {
      expect {
        subject.to_hash
      }.to raise_error(NaskEpp::ContactCredentials::Error)
    }
  end

  context "when country contains forbidden character" do
    let(:country) { "Pol{and" }

    it {
      expect {
        subject.to_hash
      }.to raise_error(NaskEpp::ContactCredentials::Error)
    }
  end

  context "when country contains forbidden character #2" do
    let(:country) { "Pola}nd" }

    it {
      expect {
        subject.to_hash
      }.to raise_error(NaskEpp::ContactCredentials::Error)
    }
  end

  context "when country contains forbidden character #3" do
    let(:country) { "P#oland" }

    it {
      expect {
        subject.to_hash
      }.to raise_error(NaskEpp::ContactCredentials::Error)
    }
  end

  context "when country contains forbidden character #4" do
    let(:country) { "Pol%and" }

    it {
      expect {
        subject.to_hash
      }.to raise_error(NaskEpp::ContactCredentials::Error)
    }
  end

  context "when country contains forbidden character #5" do
    let(:country) { "Poland;" }

    it {
      expect {
        subject.to_hash
      }.to raise_error(NaskEpp::ContactCredentials::Error)
    }
  end

  context "when country contains forbidden character #6" do
    let(:country) { "Po\\land" }

    it {
      expect {
        subject.to_hash
      }.to raise_error(NaskEpp::ContactCredentials::Error)
    }
  end

  it { pending "phone" ; fail }

  it { pending "fax" ; fail }

  it { pending "email" ; fail }

  context "when person value is not boolean" do
    let(:person) { nil }

    it {
      expect {
        subject.to_hash
      }.to raise_error(NaskEpp::ContactCredentials::Error)
    }
  end

  context "when publish value is not boolean" do
    let(:publish) { nil }

    it {
      expect {
        subject.to_hash
      }.to raise_error(NaskEpp::ContactCredentials::Error)
    }
  end

end
