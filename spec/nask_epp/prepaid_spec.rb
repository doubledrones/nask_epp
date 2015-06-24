# coding: utf-8

require 'spec_helper'

describe NaskEpp::Prepaid, :vcr do

  include_context "accounts"

  let(:the_class) { Nask }
  let(:the_object) { the_class.new(login1, password1, prefix1) }

  describe "payment_funds" do
    let(:prepaid_payment_funds_param) { "domain" }
    subject { the_object.prepaid_payment_funds(prepaid_payment_funds_param) }

    context "when not logged in" do
      it { is_expected.to be_falsey }
    end

    context "when logged in" do
      before { the_object.login(login1, password1) }

      context "when passed account_type is DOMAIN" do
        it { should > 0 }
      end

      context "when passed account_type is ENUM" do
        pending "no ENUM account type"
        it { should > 0 }
      end
    end
  end
end
