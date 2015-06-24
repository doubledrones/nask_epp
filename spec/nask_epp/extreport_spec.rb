# coding: utf-8

require 'spec_helper'

describe NaskEpp::Extreport, :vcr do

  include_context "accounts"

  let(:the_class) { Nask }
  let(:the_object) { the_class.new(login, password, prefix) }
  before { the_object.login(login, password) }

  describe "extreport_domain" do
    subject { the_object.extreport_domain(:state => state) }

    context "with state STATE_REGISTERED" do
      let(:login)    { login2 }
      let(:password) { password2 }
      let(:prefix)   { prefix2 }
      let(:state) { "STATE_REGISTERED" }

      it {
        should == [
          {
            :name=>"exampleasdzxc1231360071810.pl",
            :roid=>"863576-NASK",
            :ex_date=>"2014-02-05T13:43:31.0Z", :statuses=>[]
          },
          {
            :name=>"exampleasdzxc1231360071810.pl",
            :roid=>"863576-NASK",
            :ex_date=>"2014-02-05T13:43:31.0Z",
            :statuses=>[]
          },
          {
            :name=>"exampleasdzxc1231360071810.pl",
            :roid=>"863576-NASK",
            :ex_date=>"2014-02-05T13:43:31.0Z",
            :statuses=>[]
          },
          {
            :name=>"exampleasdzxc1231360071810.pl",
            :roid=>"863576-NASK",
            :ex_date=>"2014-02-05T13:43:31.0Z",
            :statuses=>[]
          },
          {
            :name=>"exampleasdzxc1231360071810.pl",
            :roid=>"863576-NASK",
            :ex_date=>"2014-02-05T13:43:31.0Z",
            :statuses=>[]
          },
          {
            :name=>"exampleasdzxc1231360071810.pl",
            :roid=>"863576-NASK",
            :ex_date=>"2014-02-05T13:43:31.0Z",
            :statuses=>[]
          },
          {
            :name=>"exampleasdzxc1231360071810.pl",
            :roid=>"863576-NASK",
            :ex_date=>"2014-02-05T13:43:31.0Z",
            :statuses=>[]
          },
          {
            :name=>"exampleasdzxc1231360071810.pl",
            :roid=>"863576-NASK",
            :ex_date=>"2014-02-05T13:43:31.0Z",
            :statuses=>[]
          },
          {
            :name=>"exampleasdzxc1231360071810.pl",
            :roid=>"863576-NASK",
            :ex_date=>"2014-02-05T13:43:31.0Z",
            :statuses=>[]
          },
          {
            :name=>"exampleasdzxc1231360071810.pl",
            :roid=>"863576-NASK",
            :ex_date=>"2014-02-05T13:43:31.0Z",
            :statuses=>[]
          },
          {
            :name=>"exampleasdzxc1231360071810.pl",
            :roid=>"863576-NASK",
            :ex_date=>"2014-02-05T13:43:31.0Z",
            :statuses=>[]
          },
          {
            :name=>"exampleasdzxc1231360071810.pl",
            :roid=>"863576-NASK",
            :ex_date=>"2014-02-05T13:43:31.0Z",
            :statuses=>[]
          },
          {
            :name=>"exampleasdzxc1231360071810.pl",
            :roid=>"863576-NASK",
            :ex_date=>"2014-02-05T13:43:31.0Z",
            :statuses=>[]
          },
          {
            :name=>"exampleasdzxc1231360071810.pl",
            :roid=>"863576-NASK",
            :ex_date=>"2014-02-05T13:43:31.0Z",
            :statuses=>[]
          },
          {
            :name=>"exampleasdzxc1231360071810.pl",
            :roid=>"863576-NASK",
            :ex_date=>"2014-02-05T13:43:31.0Z",
            :statuses=>[]
          },
          {
            :name=>"exampleasdzxc1231360071810.pl",
            :roid=>"863576-NASK",
            :ex_date=>"2014-02-05T13:43:31.0Z",
            :statuses=>[]
          },
          {
            :name=>"exampleasdzxc1231360071810.pl",
            :roid=>"863576-NASK",
            :ex_date=>"2014-02-05T13:43:31.0Z",
            :statuses=>[]
          },
          {
            :name=>"exampleasdzxc1231360071810.pl",
            :roid=>"863576-NASK",
            :ex_date=>"2014-02-05T13:43:31.0Z",
            :statuses=>[]
          },
          {
            :name=>"exampleasdzxc1231360071810.pl",
            :roid=>"863576-NASK",
            :ex_date=>"2014-02-05T13:43:31.0Z",
            :statuses=>[]
          },
          {
            :name=>"exampleasdzxc1231360071810.pl",
            :roid=>"863576-NASK",
            :ex_date=>"2014-02-05T13:43:31.0Z",
            :statuses=>[]
          },
          {
            :name=>"exampleasdzxc1231360071810.pl",
            :roid=>"863576-NASK",
            :ex_date=>"2014-02-05T13:43:31.0Z",
            :statuses=>[]
          },
          {
            :name=>"exampleasdzxc1231360071810.pl",
            :roid=>"863576-NASK",
            :ex_date=>"2014-02-05T13:43:31.0Z",
            :statuses=>[]
          },
          {
            :name=>"exampleasdzxc1231360071810.pl",
            :roid=>"863576-NASK",
            :ex_date=>"2014-02-05T13:43:31.0Z",
            :statuses=>[]
          },
          {
            :name=>"exampleasdzxc1231360071810.pl",
            :roid=>"863576-NASK",
            :ex_date=>"2014-02-05T13:43:31.0Z",
            :statuses=>[]
          },
          {
            :name=>"exampleasdzxc1231360071810.pl",
            :roid=>"863576-NASK",
            :ex_date=>"2014-02-05T13:43:31.0Z",
            :statuses=>[]
          },
          {
            :name=>"exampleasdzxc1231360071810.pl",
            :roid=>"863576-NASK",
            :ex_date=>"2014-02-05T13:43:31.0Z",
            :statuses=>[]
          },
          {
            :name=>"exampleasdzxc1231360071810.pl",
            :roid=>"863576-NASK",
            :ex_date=>"2014-02-05T13:43:31.0Z",
            :statuses=>[]
          },
          {
            :name=>"exampleasdzxc1231360071810.pl",
            :roid=>"863576-NASK",
            :ex_date=>"2014-02-05T13:43:31.0Z",
            :statuses=>[]
          },
          {
            :name=>"exampleasdzxc1231360071810.pl",
            :roid=>"863576-NASK",
            :ex_date=>"2014-02-05T13:43:31.0Z",
            :statuses=>[]
          },
          {
            :name=>"exampleasdzxc1231360071810.pl",
            :roid=>"863576-NASK",
            :ex_date=>"2014-02-05T13:43:31.0Z",
            :statuses=>[]
          },
          {
            :name=>"exampleasdzxc1231360071810.pl",
            :roid=>"863576-NASK",
            :ex_date=>"2014-02-05T13:43:31.0Z",
            :statuses=>[]
          },
          {
            :name=>"exampleasdzxc1231360071810.pl",
            :roid=>"863576-NASK",
            :ex_date=>"2014-02-05T13:43:31.0Z",
            :statuses=>[]
          },
          {
            :name=>"exampleasdzxc1231360071810.pl",
            :roid=>"863576-NASK",
            :ex_date=>"2014-02-05T13:43:31.0Z",
            :statuses=>[]
          },
          {
            :name=>"exampleasdzxc1231360071810.pl",
            :roid=>"863576-NASK",
            :ex_date=>"2014-02-05T13:43:31.0Z",
            :statuses=>[]
          },
          {
            :name=>"exampleasdzxc1231360071810.pl",
            :roid=>"863576-NASK",
            :ex_date=>"2014-02-05T13:43:31.0Z",
            :statuses=>[]
          },
          {
            :name=>"exampleasdzxc1231360071810.pl",
            :roid=>"863576-NASK",
            :ex_date=>"2014-02-05T13:43:31.0Z",
            :statuses=>[]
          },
          {
            :name=>"exampleasdzxc1231360071810.pl",
            :roid=>"863576-NASK",
            :ex_date=>"2014-02-05T13:43:31.0Z",
            :statuses=>[]
          },
          {
            :name=>"exampleasdzxc1231360071810.pl",
            :roid=>"863576-NASK",
            :ex_date=>"2014-02-05T13:43:31.0Z",
            :statuses=>[]
          },
          {
            :name=>"exampleasdzxc1231360071810.pl",
            :roid=>"863576-NASK",
            :ex_date=>"2014-02-05T13:43:31.0Z",
            :statuses=>[]
          },
          {
            :name=>"exampleasdzxc1231360071810.pl",
            :roid=>"863576-NASK",
            :ex_date=>"2014-02-05T13:43:31.0Z",
            :statuses=>[]
          },
          {
            :name=>"exampleasdzxc1231360071810.pl",
            :roid=>"863576-NASK",
            :ex_date=>"2014-02-05T13:43:31.0Z",
            :statuses=>[]
          },
          {
            :name=>"exampleasdzxc1231360071810.pl",
            :roid=>"863576-NASK",
            :ex_date=>"2014-02-05T13:43:31.0Z",
            :statuses=>[]
          },
          {
            :name=>"exampleasdzxc1231360071810.pl",
            :roid=>"863576-NASK",
            :ex_date=>"2014-02-05T13:43:31.0Z",
            :statuses=>[]
          },
          {
            :name=>"exampleasdzxc1231360071810.pl",
            :roid=>"863576-NASK",
            :ex_date=>"2014-02-05T13:43:31.0Z",
            :statuses=>[]
          },
          {
            :name=>"exampleasdzxc1231360071810.pl",
            :roid=>"863576-NASK",
            :ex_date=>"2014-02-05T13:43:31.0Z",
            :statuses=>[]
          },
          {
            :name=>"exampleasdzxc1231360071810.pl",
            :roid=>"863576-NASK",
            :ex_date=>"2014-02-05T13:43:31.0Z",
            :statuses=>[]
          },
          {
            :name=>"exampleasdzxc1231360071810.pl",
            :roid=>"863576-NASK",
            :ex_date=>"2014-02-05T13:43:31.0Z",
            :statuses=>[]
          },
          {
            :name=>"exampleasdzxc1231360071810.pl",
            :roid=>"863576-NASK",
            :ex_date=>"2014-02-05T13:43:31.0Z",
            :statuses=>[]
          },
          {
            :name=>"exampleasdzxc1231360071810.pl",
            :roid=>"863576-NASK",
            :ex_date=>"2014-02-05T13:43:31.0Z",
            :statuses=>[]
          },
          {
            :name=>"exampleasdzxc1231360071810.pl",
            :roid=>"863576-NASK",
            :ex_date=>"2014-02-05T13:43:31.0Z",
            :statuses=>[]
          }
        ]
      }
    end

    context "with state STATE_DELETE_BLOCKED" do
      let(:login)    { login1 }
      let(:password) { password1 }
      let(:prefix)   { prefix1 }
      let(:state) { "STATE_DELETE_BLOCKED" }

      it {
        should == []
      }
    end
  end

  describe "extreport_domain_count" do
    subject { the_object.extreport_domain_count }
    let(:login)    { login2 }
    let(:password) { password2 }
    let(:prefix)   { prefix2 }

    it { should == 79 }
  end

  describe "extreport_contact" do
    let(:login)    { login2 }
    let(:password) { password2 }
    let(:prefix)   { prefix2 }
    subject { the_object.extreport_contact(:id => id) }

    context "with single id" do
      let(:id) { 1359551872 }

      it {
        should == [
          "#{ENV['NASK_EPP_PREFIX2']}1359551872",
        ]
      }
    end

    context "without id" do
      let(:id) { nil }

      it {
        should == [
          "#{ENV['NASK_EPP_PREFIX2']}1359551872",
          "#{ENV['NASK_EPP_PREFIX2']}1359556580",
          "#{ENV['NASK_EPP_PREFIX2']}1359561091",
          "#{ENV['NASK_EPP_PREFIX2']}2",
          "#{ENV['NASK_EPP_PREFIX2']}1359632570",
          "#{ENV['NASK_EPP_PREFIX2']}1359989004",
          "#{ENV['NASK_EPP_PREFIX2']}1359991329",
          "#{ENV['NASK_EPP_PREFIX2']}1359991599",
          "#{ENV['NASK_EPP_PREFIX2']}1359992182",
          "#{ENV['NASK_EPP_PREFIX2']}1359994193",
          "#{ENV['NASK_EPP_PREFIX2']}1360000583",
          "#{ENV['NASK_EPP_PREFIX2']}1360071397",
          "#{ENV['NASK_EPP_PREFIX2']}1360071456",
          "#{ENV['NASK_EPP_PREFIX2']}1360071628",
          "#{ENV['NASK_EPP_PREFIX2']}1360071722",
          "#{ENV['NASK_EPP_PREFIX2']}1360071806",
          "#{ENV['NASK_EPP_PREFIX2']}16",
          "#{ENV['NASK_EPP_PREFIX2']}4",
          "#{ENV['NASK_EPP_PREFIX2']}20",
          "#{ENV['NASK_EPP_PREFIX2']}21",
          "#{ENV['NASK_EPP_PREFIX2']}22",
          "#{ENV['NASK_EPP_PREFIX2']}23",
          "#{ENV['NASK_EPP_PREFIX2']}26",
          "#{ENV['NASK_EPP_PREFIX2']}28",
          "#{ENV['NASK_EPP_PREFIX2']}29",
          "#{ENV['NASK_EPP_PREFIX2']}30",
          "#{ENV['NASK_EPP_PREFIX2']}31",
          "#{ENV['NASK_EPP_PREFIX2']}38",
          "#{ENV['NASK_EPP_PREFIX2']}39",
          "#{ENV['NASK_EPP_PREFIX2']}40",
          "#{ENV['NASK_EPP_PREFIX2']}41",
          "#{ENV['NASK_EPP_PREFIX2']}42",
          "#{ENV['NASK_EPP_PREFIX2']}43",
          "#{ENV['NASK_EPP_PREFIX2']}44",
          "#{ENV['NASK_EPP_PREFIX2']}45",
          "#{ENV['NASK_EPP_PREFIX2']}49",
          "#{ENV['NASK_EPP_PREFIX2']}55",
          "#{ENV['NASK_EPP_PREFIX2']}1",
          "#{ENV['NASK_EPP_PREFIX2']}9",
          "#{ENV['NASK_EPP_PREFIX2']}15",
          "#{ENV['NASK_EPP_PREFIX2']}18",
          "#{ENV['NASK_EPP_PREFIX2']}19",
          "#{ENV['NASK_EPP_PREFIX2']}24",
          "#{ENV['NASK_EPP_PREFIX2']}25",
          "#{ENV['NASK_EPP_PREFIX2']}27",
          "#{ENV['NASK_EPP_PREFIX2']}32",
          "#{ENV['NASK_EPP_PREFIX2']}33",
          "#{ENV['NASK_EPP_PREFIX2']}34",
          "#{ENV['NASK_EPP_PREFIX2']}35",
          "#{ENV['NASK_EPP_PREFIX2']}37"
        ]
      }
    end
  end

  describe "extreport_contact_count" do
    subject { the_object.extreport_contact_count }
    let(:login)    { login2 }
    let(:password) { password2 }
    let(:prefix)   { prefix2 }

    it { should == 178 }
  end

  describe "extreport_host" do
    let(:login)    { login1 }
    let(:password) { password1 }
    let(:prefix)   { prefix1 }
    subject { the_object.extreport_host(:name => name) }

    context "with single name" do
      let(:name) { "ns1174.example.pl" }

      it {
        should == ["ns1174.example.pl"]
      }
    end

    context "without name" do
      let(:name) { nil }

      it {
        should == [
          "host1346096687.example.pl",
          "host1346096688.example.pl",
          "host1346096691.example.pl",
          "ns1174.example.pl",
          "host1346094831.example.pl",
          "host1346096785.example.pl",
          "host1346096686.example.pl",
          "host1346098307.example.pl",
          "host1346098311.example.pl",
          "host1346095586.example.pl",
          "host1346095495.example.pl",
          "host1346098234.example.pl",
          "host1346095049.example.pl",
          "host1346095050.example.pl",
          "host1346092440.example.pl",
          "host1346092468.example.pl",
          "host1346095646.example.pl",
          "host1346095745.example.pl",
          "host1346098334.example.pl",
          "host1346098330.example.pl",
          "host1346097537.example.pl",
          "host1346091602.example.pl",
          "host1346091609.example.pl",
          "host1346092633.example.pl",
          "host1346092635.example.pl",
          "host1346096692.example.pl",
          "host1346098290.example.pl",
          "host1346095497.example.pl",
          "host1346095494.example.pl",
          "host1346132106.example1346132101.pl",
          "host1346135220.example1346135214.pl",
          "host1346135221.example1346135214.pl",
          "host1346132112.example1346132099.pl",
          "host1346134799.example1346134795.pl",
          "host1346134803.example1346134795.pl",
          "host1346135224.example1346135212.pl",
          "host1346132103.example1346132101.pl",
          "host1346135216.example1346135214.pl",
          "host1346135219.example1346135214.pl",
          "host1346132111.example1346132099.pl",
          "host1346134802.example1346134795.pl",
          "host1346132171.example1346132161.pl",
          "host1346135222.example1346135214.pl",
          "host1346132107.example1346132101.pl",
          "host1346135225.example1346135212.pl",
          "host1346135218.example1346135214.pl",
          "host1346135223.example1346135214.pl",
          "host1346132102.example1346132101.pl",
          "host1346134799.example1346134787.pl",
          "host1346134799.example1346134789.pl"
        ]
      }
    end
  end

  describe "extreport_host_count" do
    subject { the_object.extreport_host_count }
    let(:login)    { login1 }
    let(:password) { password1 }
    let(:prefix)   { prefix1 }

    it { should == 548 }
  end

end
