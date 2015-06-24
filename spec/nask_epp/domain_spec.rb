# coding: utf-8

require 'spec_helper'

describe NaskEpp::Domain, :vcr do

  include_context "accounts"
  include_context "contacts"

  let(:the_class) { Nask }
  let(:the_object) { the_class.new(login, password, prefix) }

  let(:host_num) { 1360074258 }
  let(:domain_name) { "example#{host_num}.pl" }
  let(:domain_params) { {
    :name => domain_name,
    :period => 1,
    :contact => "#{prefix}#{contact_id}",
    :registrant => "#{prefix}#{contact_id}",
    :ns => [host_params1[:name], host_params2[:name]],
    :pw => "yyyyyyyy#{Time.now.to_i}"
  } }

  let(:ns_domain_name) { "prostydns.pl" }
  let(:ns_domain_params) { {
    :name => domain_name,
    :period => 1,
    :contact => "#{prefix}#{contact_id}",
    :registrant => "#{prefix}#{contact_id}",
    :ns => [host_params1[:name], host_params2[:name]],
    :pw => "xxxxxxxx"
  } }

  let(:host_params1) { {
    :name => "ns1.prostydns.pl",
    :ipv4 => ["31.186.86.138"]
  } }

  let(:host_params2) { {
    :name => "ns2.prostydns.pl",
    :ipv4 => ["176.9.20.181"]
  } }

  let(:host_params3) { {
    :name => "example123.#{domain_name}",
    :ipv4 => ["31.186.86.138"]
  } }

  let(:host_params4) { {
    :name => "example123-2.#{domain_name}",
    :ipv4 => ["31.186.86.138"]
  } }

  describe "create" do
    subject { the_object.domain_create(domain_params) }

    describe "first account" do
      let(:login)    { login1 }
      let(:password) { password1 }
      let(:prefix)   { prefix1 }

      context "when not logged in" do
        it { is_expected.to be_falsey }
      end

      context "when logged in" do
        before { the_object.login(login, password) }

        context "when there is no contact" do
          it { is_expected.to be_falsey }
        end

        context "when contact exist" do
          before { the_object.contact_create(contact_data) }


          context "when nameserver hosts does not exists" do
            before do
              the_object.host_delete(host_params1[:name])
              the_object.host_delete(host_params2[:name])
            end

            it { is_expected.to be_falsey }
          end

          context "when nameserver hosts exists" do
            before do
              the_object.host_create(host_params1)
              the_object.host_create(host_params2)
              the_object.domain_create(ns_domain_params)
            end

            context "when domain already exist" do
              before { the_object.domain_create(domain_params) }

              it { is_expected.to be_falsey }
            end

            context "when domain does not exist" do
              before { the_object.domain_delete(domain_name) }

              context "without additional params" do
                it { pending "need to record VCR" ; is_expected.to be_truthy }
              end

              context "with book param" do
                let(:domain_params) { {
                  :name => domain_name,
                  :ns => [host_params1[:name], host_params2[:name]],
                  :pw => "yyyyy#{Time.now.to_i}",
                  :book => true
                } }

                it { pending "need to record VCR" ; is_expected.to be_truthy }
              end

              context "with taste param" do
                let(:domain_params) { {
                  :name => domain_name,
                  :contact => "#{prefix}#{contact_id}",
                  :registrant => "#{prefix}#{contact_id}",
                  :ns => [host_params1[:name], host_params2[:name]],
                  :pw => "yyyyy#{Time.now.to_i}",
                  :taste => true
                } }

                it { pending "need to record VCR" ; is_expected.to be_truthy }
              end

              context "when it is not .pl domain" do
                let(:domain_name) { "example#{host_num}.com" }

                it { is_expected.to be_falsey }
              end

              context "when it is czest.pl domain" do
                let(:domain_name) { "example#{host_num+1}.czest.pl" }

                it { pending "need to record VCR" ; is_expected.to be_truthy }
              end
            end
          end
        end
      end
    end
  end

  describe "remove_status" do
    it "should be tested when functionality used"
  end

  describe "info" do
    subject { the_object.domain_info(domain_name, { :pw => domain_params[:pw] }) }

    describe "first account" do
      let(:login)    { login1 }
      let(:password) { password1 }
      let(:prefix)   { prefix1 }

      context "when not logged in" do
        it { should be_nil }
      end

      context "when logged in" do
        before { the_object.login(login, password) }

        context "when there is no contact" do
          it { should be_nil }
        end

        context "when contact exist" do
          before { the_object.contact_create(contact_data) }


          context "when nameserver hosts does not exists" do
            before do
              the_object.host_delete(host_params1[:name])
              the_object.host_delete(host_params2[:name])
            end

            it { should be_nil }
          end

          context "when nameserver hosts exists" do
            before do
              the_object.host_create(host_params1)
              the_object.host_create(host_params2)
              the_object.domain_create(ns_domain_params)
            end

            context "when domain already exist" do
              before { the_object.domain_create(domain_params) }


              # TODO: need to record VCR
              # it { expect(subject[:name]).to eq domain_name }

              # TODO: need to record VCR
              # it { expect(subject[:roid]).to match /^[0-9]+-NASK$/ }
            end

            context "when domain does not exist" do
              before { the_object.domain_delete(domain_name) }

              it { should be_nil }
            end
          end
        end
      end
    end
  end

  describe "check" do
    describe "first account" do
      let(:login)    { login1 }
      let(:password) { password1 }
      let(:prefix)   { prefix1 }

      describe "one domain" do

        context "when there is domain" do
          subject { the_object.domain_check("wp.pl") }

          context "when not logged in" do
            it { should be_nil }
          end

          context "when logged in" do
            before { the_object.login(login, password) }
            it  { is_expected.to be_falsey }
          end
        end

        context "when there is no domain" do
          let(:domain_name) { "example123123123123.pl" }
          subject { the_object.domain_check(domain_name) }

          context "when not logged in" do
            it { should be_nil }
          end

          context "when logged in" do
            before { the_object.login(login, password) }
            it { is_expected.to be_truthy }
          end
        end
      end

      describe "two domains" do
        context "when first domain exist and second not exist" do
          subject { the_object.domain_check("wp.pl", "example123123123123.pl") }

          context "when not logged in" do
            it { should be_nil }
          end

          context "when logged in" do
            before { the_object.login(login, password) }

            # TODO: need to record VCR
            # it { expect(subject["wp.pl"]).to be_falsey }

            # TODO: need to record VCR
            # it { expect(subject["example123123123123.pl"]).to be_truthy }
          end
        end
      end
    end
  end

  describe "update" do
    subject { the_object.domain_update(domain_name, domain_update_params) }

    let(:domain_update_params) { { :pw => nil } }

    let(:login)    { login1 }
    let(:password) { password1 }
    let(:prefix)   { prefix1 }

    context "when not logged in" do
      it { is_expected.to be_falsey }
    end

    context "when logged in" do
      before { the_object.login(login, password) }

      context "when domain not exist" do
        it { is_expected.to be_falsey }
      end

      context "when domain exist" do
        before do
          the_object.contact_create(contact_data)
          the_object.host_create(host_params1)
          the_object.host_create(host_params2)
          the_object.domain_create(ns_domain_params)
          the_object.domain_create(domain_params)
        end

        describe "change delegation" do
          let(:domain_update_params) { {
            :ns_rem => [host_params1[:name], host_params2[:name]],
            :ns_add => [host_params3[:name], host_params4[:name]],
          } }

          context "when hosts not exists" do
            it { is_expected.to be_falsey }
          end

          context "when hosts exists" do
            before do
              the_object.host_create(host_params3)
              the_object.host_create(host_params4)
            end

            it { pending "need to record VCR" ; is_expected.to be_truthy }
          end
        end

        describe "change password" do

          context "when password is wrong" do
            let(:domain_update_params) { { :pw => "1234a" } }

            it { is_expected.to be_falsey }
          end

          context "when password is ok" do
            let(:domain_update_params) { { :pw => "#{Time.now.to_i}" } }

            it { is_expected.to be_truthy }
          end
        end

        describe "change ClientUpdateProhibited status" do

          context "add status" do
            let(:domain_update_params) { { :client_update_prohibited => true } }

            it { is_expected.to be_truthy }
          end

          context "remove status" do
            let(:domain_update_params) { { :client_update_prohibited => false } }

            context "when there is no status" do
              it { pending "need to record VCR" ; is_expected.to be_falsey }
            end

            context "when there is status" do
              before { the_object.domain_update(domain_name, {:client_update_prohibited => true}) }

              it { is_expected.to be_truthy }
            end
          end
        end

        describe "change ClientRenewProhibited status" do

          context "add status" do
            let(:domain_update_params) { { :client_renew_prohibited => true } }

            it { is_expected.to be_truthy }
          end

          context "remove status" do
            let(:domain_update_params) { { :client_renew_prohibited => false } }

            context "when there is no status" do
              # TODO: need to record VCR
              # it { is_expected.to be_falsey }
            end

            context "when there is status" do
              before { the_object.domain_update(domain_name, {:client_renew_prohibited => true}) }

              it { is_expected.to be_truthy }
            end
          end
        end
      end
    end
  end

  describe "delete" do
    subject { the_object.domain_delete(domain_name) }

    let(:login)    { login1 }
    let(:password) { password1 }
    let(:prefix)   { prefix1 }

    context "when not logged in" do
      it { is_expected.to be_falsey }
    end

    context "when logged in" do
      before { the_object.login(login, password) }

      context "when domain not exist" do
        it { is_expected.to be_falsey }
      end

      context "when domain exist" do
        before do
          the_object.contact_create(contact_data)
          the_object.host_create(host_params1)
          the_object.host_create(host_params2)
          the_object.domain_create(ns_domain_params)
          the_object.domain_create(domain_params)
        end

        it { pending "need to record VCR" ; is_expected.to be_truthy }
      end
    end
  end

  describe "renew" do
    subject { the_object.domain_renew(domain_name, domain_renew_params) }

    let(:login)    { login1 }
    let(:password) { password1 }
    let(:prefix)   { prefix1 }

    let(:cur_exp_date) { nil }
    let(:domain_renew_params) { {
      :period => 1,
      :cur_exp_date => cur_exp_date,
    } }

    context "when not logged in" do
      it { is_expected.to be_falsey }
    end

    context "when logged in" do
      before { the_object.login(login, password) }

      context "when domain not exist" do
        it { is_expected.to be_falsey }
      end

      context "when domain exist" do
        before do
          the_object.contact_create(contact_data)
          the_object.host_create(host_params1)
          the_object.host_create(host_params2)
          the_object.domain_create(ns_domain_params)
          the_object.domain_create(domain_params)
        end

        context "when passed wrong current expire date" do
          let(:cur_exp_date) { Time.now.strftime("%Y-%m-%d") }

          it { is_expected.to be_falsey }
        end

        context "when passed proper current expire date" do
          let(:cur_exp_date) { the_object.domain_info(domain_name)[:exDate][0..9] }

          it { pending "need to record VCR" ; is_expected.to be_truthy }
        end
      end
    end
  end

  describe "list_hosts" do
    let(:login)    { login1 }
    let(:password) { password1 }
    let(:prefix)   { prefix1 }
    before { the_object.login(login, password) }
    subject { the_object.domain_list_hosts("prostydns.pl") }

    it {
      pending "need to record VCR"
      should == [
        "host1346128242.prostydns.pl",
        "host1346128244.prostydns.pl",
        "host1346128246.prostydns.pl",
        "host1346129438.prostydns.pl",
        "host1346129465.prostydns.pl",
        "host1346129566.prostydns.pl",
        "host1346132066.prostydns.pl",
        "host1346132068.prostydns.pl",
        "host1346132064.prostydns.pl",
        "host1346132070.prostydns.pl",
        "host1346134901.prostydns.pl",
        "host1347513940.prostydns.pl",
        "host1347513944.prostydns.pl",
        "host1347513947.prostydns.pl",
        "host1347513949.prostydns.pl",
        "host1347513952.prostydns.pl",
        "host1347513953.prostydns.pl",
        "host1347518368.prostydns.pl",
        "host1347518373.prostydns.pl",
        "host1347518371.prostydns.pl",
        "host1347518375.prostydns.pl",
        "host1347518380.prostydns.pl",
        "host1347518387.prostydns.pl",
        "host1346128710.prostydns.pl",
        "host1346128711.prostydns.pl",
        "host1346128708.prostydns.pl",
        "host1346128714.prostydns.pl",
        "host1346128716.prostydns.pl",
        "host1346129576.prostydns.pl",
        "host1346129577.prostydns.pl",
        "host1346129578.prostydns.pl",
        "host1346129580.prostydns.pl",
        "host1346129583.prostydns.pl",
        "host1346130929.prostydns.pl",
        "host1346130931.prostydns.pl",
        "host1346130926.prostydns.pl",
        "host1346130933.prostydns.pl",
        "host1346130934.prostydns.pl",
        "host1346131108.prostydns.pl",
        "host1346131110.prostydns.pl",
        "host1346131113.prostydns.pl",
        "host1346131118.prostydns.pl",
        "host1346131119.prostydns.pl",
        "host1346131403.prostydns.pl",
        "host1346131409.prostydns.pl",
        "host1346131406.prostydns.pl",
        "host1346131411.prostydns.pl",
        "host1346131413.prostydns.pl",
        "host1346134906.prostydns.pl",
        "host1346134909.prostydns.pl",
        "host1346134911.prostydns.pl",
        "host1346134914.prostydns.pl",
        "host1346134916.prostydns.pl",
        "host1346129313.prostydns.pl",
        "host1346128249.prostydns.pl",
        "host1346135258.prostydns.pl",
        "host1346135262.prostydns.pl",
        "host1346135265.prostydns.pl",
        "host1346135267.prostydns.pl",
        "host1346135270.prostydns.pl",
        "host1346135271.prostydns.pl",
        "host1346124953.prostydns.pl",
        "host1346127580.prostydns.pl",
        "host1346127576.prostydns.pl",
        "host1346127579.prostydns.pl",
        "host1346127874.prostydns.pl",
        "host1346129261.prostydns.pl",
        "host1346135070.prostydns.pl",
        "host1346127995.prostydns.pl",
        "host1346127582.prostydns.pl",
        "host1346127994.prostydns.pl",
        "host1346127997.prostydns.pl",
        "host1346127999.prostydns.pl",
        "host1346128002.prostydns.pl",
        "host1346128241.prostydns.pl",
        "host1350293713.prostydns.pl",
        "host1350293725.prostydns.pl",
        "host1350293707.prostydns.pl",
        "host1350291957.prostydns.pl",
        "host1350291961.prostydns.pl",
        "host1350291963.prostydns.pl",
        "host1350291966.prostydns.pl",
        "host1350293731.prostydns.pl",
        "host1350293734.prostydns.pl",
        "host1350294053.prostydns.pl",
        "host1350294057.prostydns.pl",
        "host1350294071.prostydns.pl",
        "host1350291973.prostydns.pl",
        "host1350291980.prostydns.pl",
        "host1350294059.prostydns.pl",
        "host1350294061.prostydns.pl",
        "host1350294066.prostydns.pl",
        "host1350293720.prostydns.pl",
        "host1350297191.prostydns.pl",
        "host1350297195.prostydns.pl",
        "host1350297199.prostydns.pl",
        "host1350297202.prostydns.pl",
        "host1350297206.prostydns.pl",
        "host1350297208.prostydns.pl",
        "host1360075637.prostydns.pl",
        "host1360075651.prostydns.pl",
        "host1360075634.prostydns.pl",
        "host1360075665.prostydns.pl",
        "host1360075641.prostydns.pl",
        "host1360075675.prostydns.pl"
      ]
    }
  end

end
