# coding: utf-8

require 'spec_helper'

describe NaskEpp::Poll, :vcr do

  include_context "accounts"

  let(:login) { login1 }
  let(:password) { password1 }
  let(:prefix) { prefix1 }

  let(:the_class) { Nask }
  let(:the_object) { the_class.new(login, password, prefix) }

  describe "poll_req" do
    subject { the_object.poll_req }

    context "when logged in" do
      before { the_object.login(login1, password1) }

      its [:msg_id] { should == 342053 }
      its [:msg] { should == "broken delegation" }
    end

    context "when not logged in" do
      it { is_expected.to be_falsey }
    end
  end

  describe "poll_ack" do
    subject { the_object.poll_ack(msg_id)}
    before do
      the_object.login(login1, password1)
    end

    context "when logged in" do

      context "when no msg_id passed" do
        let(:msg_id) { nil }

        it { is_expected.to be_falsey }
      end

      context "when no msg_id passed" do
        let(:msg_id) { the_object.poll_req[:msg_id] }

        it { is_expected.to be_truthy }
      end
    end

    context "when not logged in" do
      let(:msg_id) { nil }
      before { the_object.logout }

      it { is_expected.to be_falsey }
    end
  end

end
