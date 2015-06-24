# coding: utf-8

require 'spec_helper'

describe NaskEpp::Future, :vcr do

  include_context "accounts"
  include_context "contacts"

  let(:the_class) { Nask }
  let(:the_object) { the_class.new(login1, password1, prefix1) }
  let(:the_object2) { the_class.new(login2, password2, prefix2) }

  let(:num) { Time.now.to_i }

  let(:contact_id) { num }

  let(:host_params1) { {
    :name => "ns1.prostydns.pl",
    :ipv4 => ["31.186.86.138"]
  } }

  let(:host_params2) { {
    :name => "ns2.prostydns.pl",
    :ipv4 => ["176.9.20.181"]
  } }

  let(:ns_domain_name) { "prostydns.pl" }
  let(:ns_domain_params) { {
    :name => ns_domain_name,
    :period => 1,
    :contact => "#{prefix1}#{contact_id}",
    :registrant => "#{prefix1}#{contact_id}",
    :ns => [host_params1[:name], host_params2[:name]],
    :pw => "xxxxxxxx"
  } }

  let(:domain_name) { "example#{num}.pl" }
  let(:domain_params) { {
    :name => domain_name,
    :period => 1,
    :contact => "#{prefix1}#{contact_id}",
    :registrant => "#{prefix1}#{contact_id}",
    :ns => [host_params1[:name], host_params2[:name]],
    :pw => "yyyyyyyy#{num}"
  } }

  let(:future_name) { domain_name }
  let(:future_params) { {
    :name => future_name,
    :period => 3,
    :registrant => "#{prefix1}#{contact_id}",
    :pw => "fyyyyyyyyyx#{num}"
  } }

  describe "create" do
    subject { the_object.future_create(future_params) }

    context "when not logged in" do
      it { is_expected.to be_falsey }
    end

    context "when logged in" do
      before { the_object.login(login1, password1) }

      context "when there is no domain" do
        it { is_expected.to be_falsey }
      end

      context "when there is domain" do
        before do
          the_object.contact_create(contact_data)
          the_object.host_create(host_params1)
          the_object.host_create(host_params2)
          the_object.domain_create(ns_domain_params)
          the_object.domain_create(domain_params)
        end

        context "when period is below 3" do

          it { is_expected.to be_truthy }
        end
      end
    end
  end

  describe "transfer" do
    let(:future_transfer_op_param) { "request" }
    subject { the_object2.future_transfer(future_name, {:op => future_transfer_op_param, :pw => "fyyyyyyyyyx#{num}"}) }

    context "when not logged in" do
      it { is_expected.to be_falsey }
    end

    context "when logged in" do
      before { the_object2.login(login2, password2) }

      context "when there is no domain" do
        it { is_expected.to be_falsey }
      end

      context "when there is domain" do
        before do
          the_object.login(login1, password1)
          the_object.contact_create(contact_data)
          the_object.host_create(host_params1)
          the_object.host_create(host_params2)
          the_object.domain_create(ns_domain_params)
          the_object.domain_create(domain_params)
        end

        context "when there is no future" do
          it { is_expected.to be_falsey }
        end

        context "when there is future" do
          before { the_object.future_create(future_params) }

          context "with op param set to request" do
            let(:future_transfer_op_param) { "request" }

            it { is_expected.to be_truthy }
          end

          context "when there is future transfer" do
            before { the_object2.future_transfer(future_name, {:op => "request", :pw => "fyyyyyyyyyx#{num}"}) }
            context "with op param set to query" do
              let(:future_transfer_op_param) { "query" }

              it { is_expected.to be_truthy }
            end

            context "with op param set to cancel" do
              let(:future_transfer_op_param) { "cancel" }

              it { is_expected.to be_truthy }
            end
          end
        end
      end
    end
  end

  describe "check" do

    describe "single future" do

      let(:future_check_params) { domain_name }

      context "when not logged in" do
        subject { the_object.future_check(future_check_params)}

        it { is_expected.to be_falsey }
      end

      context "when logged in" do
        subject { the_object.future_check(future_check_params)[future_check_params] }

        before { the_object.login(login1, password1) }

        context "when there is no domain" do
          let(:num) { 1360077289 }
          it { should == "false" }
        end

        context "when there is domain" do
          before do
            the_object.contact_create(contact_data)
            the_object.host_create(host_params1)
            the_object.host_create(host_params2)
            the_object.domain_create(ns_domain_params)
            the_object.domain_create(domain_params)
          end

          context "when there is no future" do
            let(:num) { 1360077320 }
            it { should == "true" }
          end

          context "where there is future" do
            let(:num) { 1360077350 }
            before { the_object.future_create(future_params) }

            it { should == "false" }
          end
        end
      end
    end

    describe "multiple futures" do

      let(:future_check_params1) { "example#{num}.pl" }
      let(:future_check_params2) { "exampleex#{num}-2.pl" }

      context "when not logged in" do
        subject { the_object.future_check(future_check_params1, future_check_params2)}

        it { is_expected.to be_falsey }
      end

      context "when logged in" do
        before { the_object.login(login1, password1) }

        context "when there are no domains" do
          let(:num) { 1360077468 }
          subject { the_object.future_check(future_check_params1, future_check_params2)[future_check_params1] }
          it { should == "false" }
          subject { the_object.future_check(future_check_params1, future_check_params2)[future_check_params2] }
          it { should == "false" }
        end

        context "when there are domains" do
          before do
            the_object.contact_create(contact_data)
            the_object.host_create(host_params1)
            the_object.host_create(host_params2)
            the_object.domain_create(ns_domain_params)
            the_object.domain_create(domain_params)
            the_object.domain_create(
              :name => "exampleex#{num}-2.pl",
              :period => 1,
              :contact => "#{prefix1}#{contact_id}",
              :registrant => "#{prefix1}#{contact_id}",
              :ns => [host_params1[:name], host_params2[:name]],
              :pw => "yyyyyyyyads#{num}")
          end

          context "when there are no futures" do
            let(:num) { 1360077983 }
            subject { the_object.future_check(future_check_params1, future_check_params2)[future_check_params1] }
            it { should == "true" }
            subject { the_object.future_check(future_check_params1, future_check_params2)[future_check_params2] }
            it { should == "true" }
          end

          context "when there are futures" do
            let(:num) { 1433347683 }
            before do
              the_object.future_create(future_params)
              the_object.future_create(
                :name => "exampleex#{num}-2.pl",
                :period => 3,
                :registrant => "#{prefix1}#{contact_id}",
                :pw => "fyyyyyyyyyx#{num}")
            end

            subject { the_object.future_check(future_check_params1, future_check_params2)[future_check_params1] }
            it { should == "false" }
          end
        end
      end
    end
  end

  describe "info" do
    subject { the_object.future_info(future_info_params1, future_info_params2)}

    let(:future_info_params1) { "example#{num}.pl" }
    let(:future_info_params2) { { :pw =>"fyyyyyyyyyx#{num}" } }

    context "when not logged in" do
      it { is_expected.to be_falsey }
    end

    context "when logged in" do
      before { the_object.login(login1, password1) }

      context "when there is no domain" do
        it { is_expected.to be_falsey }
      end

      context "when there is domain" do
        before do
          the_object.contact_create(contact_data)
          the_object.host_create(host_params1)
          the_object.host_create(host_params2)
          the_object.domain_create(ns_domain_params)
          the_object.domain_create(domain_params)
        end

        context "when there is no future" do
          it { is_expected.to be_falsey }
        end

        context "when there is future" do
          let(:num) { 1360076768 }
          before do
            the_object.future_create(future_params)
          end

          context "from registrant account which created future" do
            its [:name] { should == "example#{num}.pl" }
          end
        end
      end
    end
  end

  describe "renew" do
    cur_exp_date = Time.now.strftime("%Y-%m-%d")
    cur_exp_date = (cur_exp_date[0..3].to_i + 3).to_s + cur_exp_date[4..9]
    subject { the_object.future_renew(future_name, {:period => 3, :cur_exp_date => cur_exp_date}) }

    context "when not logged in" do
      it { is_expected.to be_falsey }
    end

    context "when logged in" do
      before { the_object.login(login1, password1) }

      context "when there is no domain" do
        it { is_expected.to be_falsey }
      end

      context "when there is domain" do
        before do
          the_object.contact_create(contact_data)
          the_object.host_create(host_params1)
          the_object.host_create(host_params2)
          the_object.domain_create(ns_domain_params)
          the_object.domain_create(domain_params)
        end

        context "when there is no future" do
          it { is_expected.to be_falsey }
        end

        context "when there is future" do
          before do
            the_object.future_create(future_params)
          end

          it { is_expected.to be_truthy }
        end
      end
    end
  end

  describe "delete" do
    subject { the_object.future_delete(future_name) }

    context "when not logged in" do
      it { is_expected.to be_falsey }
    end

    context "when logged in" do
      before { the_object.login(login1, password1) }

      context "when there is no domain" do
        it { is_expected.to be_falsey }
      end

      context "when there is domain" do
        before do
          the_object.contact_create(contact_data)
          the_object.host_create(host_params1)
          the_object.host_create(host_params2)
          the_object.domain_create(ns_domain_params)
          the_object.domain_create(domain_params)
        end

        context "when there is no future" do
          it { is_expected.to be_falsey }
        end

        context "when there is future" do
          before do
            the_object.future_create(future_params)
          end

          it { is_expected.to be_truthy }
        end
      end
    end
  end

  describe "update" do
    let(:future_update_params) { { :pw => "qweqeqwewqesadasd#{num}" } }
    subject { the_object.future_update(future_name, future_update_params) }

    context "when not logged in" do
      it { is_expected.to be_falsey }
    end

    context "when logged in" do
      before { the_object.login(login1, password1) }

      context "when there is no domain" do
        it { is_expected.to be_falsey }
      end

      context "when there is domain" do
        before do
          the_object.contact_create(contact_data)
          the_object.host_create(host_params1)
          the_object.host_create(host_params2)
          the_object.domain_create(ns_domain_params)
          the_object.domain_create(domain_params)
        end

        context "when there is no future" do
          it { is_expected.to be_falsey }
        end

        context "when there is future" do
          before { the_object.future_create(future_params) } 

          it { is_expected.to be_truthy }
        end
      end
    end
  end

end
