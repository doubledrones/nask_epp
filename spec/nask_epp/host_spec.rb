# coding: utf-8

require 'spec_helper'

describe NaskEpp::Host, :vcr do

  include_context "accounts"

  let(:the_class) { Nask }
  let(:the_object) { the_class.new(login, password, prefix) }

  let(:num) { 1360075622 }
  let(:host_name) { "host#{num}.example#{num}.pl" }
  let(:host_params) { {
    :name => host_name,
    :ipv4 => ["31.186.86.138"]
  } }

  describe "create" do
    subject { the_object.host_create(host_params) }

    describe "first account" do
      let(:login)    { login1 }
      let(:password) { password1 }
      let(:prefix)   { prefix1 }

      context "when not logged in" do
        it { is_expected.to be_falsey }
      end

      context "when logged in" do
        before { the_object.login(login, password) }

        context "when host already exist" do
          before { the_object.host_create(host_params) }

          it { is_expected.to be_falsey }
        end

        context "when host does not exist" do
          before { the_object.host_delete(host_name) }

          it { is_expected.to be_truthy }
        end
      end
    end
  end

  describe "delete" do
    subject { the_object.host_delete(host_name) }

    describe "first account" do
      let(:login)    { login1 }
      let(:password) { password1 }
      let(:prefix)   { prefix1 }

      context "when not logged in" do
        it { is_expected.to be_falsey }
      end

      context "when logged in" do
        before { the_object.login(login, password) }

        context "when host already exist" do
          before { the_object.host_create(host_params) }

          it { pending "WIP: need to remove 'pendingCreate' status" ; is_expected.to be_truthy }
        end

        context "when host does not exist" do
          before { the_object.host_delete(host_name) }

          it { is_expected.to be_falsey }
        end
      end
    end
  end

  describe "info" do
    subject { the_object.host_info(host_name) }

    describe "first account" do
      let(:login)    { login1 }
      let(:password) { password1 }
      let(:prefix)   { prefix1 }

      context "when not logged in" do
        it { should be_nil }
      end

      context "when logged in" do
        before { the_object.login(login, password) }

        context "when host already exist" do
          before { the_object.host_delete(host_name) }
          before { the_object.host_create(host_params) }

          it { should == {
            :addr => "31.186.86.138",
            :name => host_name,
            :status => "pendingCreate"
          } }
        end

        context "when host does not exist" do
          before { the_object.host_delete(host_name) }

          it { pending "WIP: need to remove 'pendingCreate' status" ; should be_nil }
        end
      end
    end
  end

  describe "change_addr" do
    subject { the_object.host_change_addr(host_name, "176.9.20.181") }

    describe "first account" do
      let(:login)    { login1 }
      let(:password) { password1 }
      let(:prefix)   { prefix1 }

      context "when not logged in" do
        it { is_expected.to be_falsey }
      end

      context "when logged in" do
        before { the_object.login(login, password) }

        context "when host already exist" do
          before { the_object.host_delete(host_name) }
          before { the_object.host_create(host_params) }

          it { pending "need to record VCR" ; is_expected.to be_truthy }
        end

        context "when host does not exist" do
          before { the_object.host_delete(host_name) }

          it { is_expected.to be_falsey }
        end
      end
    end
  end

  describe "host_status_ok?" do
    subject { the_object.host_status_ok?(host_name) }

    describe "first account" do
      let(:login)    { login1 }
      let(:password) { password1 }
      let(:prefix)   { prefix1 }

      context "when not logged in" do
        it { is_expected.to be_falsey }
      end

      context "when logged in" do
        before { the_object.login(login, password) }

        context "when host already exist" do
          before { the_object.host_delete(host_name) }
          before { the_object.host_create(host_params) }

          it { pending "need to record VCR" ; is_expected.to be_truthy }
        end

        context "when host does not exist" do
          before { the_object.host_delete(host_name) }

          it { is_expected.to be_falsey }
        end
      end
    end
  end

end
