# coding: utf-8

require 'spec_helper'

describe NaskEpp::Contact, :vcr do

  include_context "accounts"
  include_context "contacts"

  let(:num) { 11121115131 }
  let(:contact_id) { num }
  let(:contact_id2) { num+1 }

  let(:the_class) { Nask }
  let(:the_object) { the_class.new(login, password, prefix) }

  let(:credentials) { contact_data2 }

  let(:credentials2) { contact_data2.merge(:contact_id => contact_id2) }

  describe "check" do

    describe "first account" do
      let(:login)    { login1 }
      let(:password) { password1 }
      let(:prefix)   { prefix1 }

      describe "one contact_id" do
        subject { the_object.contact_check(contact_id) }

        context "when not logged in" do
          it { is_expected.to be_falsey }
        end

        context "when logged in" do
          before { the_object.login(login, password) }

          context "when there is no contact_id" do
            it { expect(subject[contact_id]).to be_truthy }
          end

          context "when there is contact_id" do
            before { the_object.contact_create(credentials) }

            it { expect(subject[contact_id]).to be_falsey }
          end
        end
      end

      describe "multiple contacts_ids" do
        subject { the_object.contact_check(contact_id, contact_id2) }

        context "when not logged in" do
          it { is_expected.to be_falsey }
        end

        context "when logged in" do
          before { the_object.login(login, password) }

          context "when there are no contacts_ids" do
            let(:num) { 12366175131 }

            it "should return true values" do
              expect(subject[contact_id]).to be_truthy
              expect(subject[contact_id2]).to be_truthy
            end
          end

          context "when there is contact_id" do
            before do
              the_object.contact_create(credentials)
              the_object.contact_create(credentials2)
            end

            it "should return false values" do
              expect(subject[contact_id]).to be_falsey
              expect(subject[contact_id2]).to be_falsey
            end
          end
        end
      end
    end
  end

  describe "create" do
    subject { the_object.contact_create(credentials) }

    describe "first account" do
      let(:login)    { login1 }
      let(:password) { password1 }
      let(:prefix)   { prefix1 }

      context "when not logged in" do
        it { is_expected.to be_falsey }
      end

      context "when logged in" do
        before { the_object.login(login, password) }

        context "when contact already exist" do
          before { the_object.contact_create(credentials) }

          it { is_expected.to be_falsey }
        end

        context "when contact does not exist" do
          before { the_object.contact_delete(contact_id) }

          it { is_expected.to be_truthy }
        end
      end
    end
  end

  describe "delete" do
    subject { the_object.contact_delete(contact_id) }

    describe "first account" do
      let(:login)    { login1 }
      let(:password) { password1 }
      let(:prefix)   { prefix1 }

      context "when not logged in" do
        it { is_expected.to be_falsey }
      end

      context "when logged in" do
        before { the_object.login(login, password) }

        context "when contact already exist" do
          before { the_object.contact_create(credentials) }

          it { is_expected.to be_truthy }
        end

        context "when contact does not exist" do
          before { the_object.contact_delete(contact_id) }

          it { is_expected.to be_falsey }
        end
      end
    end
  end

  describe "info" do
    subject { the_object.contact_info(contact_id) }

    describe "first account" do
      let(:login)    { login1 }
      let(:password) { password1 }
      let(:prefix)   { prefix1 }

      context "when not logged in" do
        it { should be_nil }
      end

      context "when logged in" do
        before { the_object.login(login, password) }

        context "when contact already exist" do
          before { the_object.contact_delete(contact_id) }
          before { the_object.contact_create(credentials) }

          # TODO: need to record VCR
          # it { should == contact_data2.merge(:contact_id => contact_id.to_i) }
        end

        context "when contact does not exist" do
          before { the_object.contact_delete(contact_id) }

          it { should be_nil }
        end
      end
    end
  end

  describe "update" do
    let(:params) { {:email => "new@example.com"} }
    subject { the_object.contact_update(contact_id, params) }

    describe "first account" do
      let(:login)    { login1 }
      let(:password) { password1 }
      let(:prefix)   { prefix1 }

      context "when not logged in" do
        it { is_expected.to be_falsey }
      end

      context "when logged in" do
        before { the_object.login(login, password) }

        context "when contact already exist" do
          before { the_object.contact_delete(contact_id) }
          before { the_object.contact_create(credentials) }

          it { is_expected.to be_truthy }

          context "changing name" do
            let(:params) { {:name => "Jackob Spicy"} }

            it { is_expected.to be_truthy }
          end

          context "changing address" do
            #These are obligatory if you want to change address
            let(:params) { {:city => "Łódź", :street => "Mickiewicza 16/3", :country => "DE" } }

            it { is_expected.to be_truthy }
          end

          context "changing province" do
            let(:params) { {:province => "Mazowieckie"} }

            it { is_expected.to be_falsey }
          end

          context "changing zip_code" do
            let(:params) { {:zip_code => "42-222"} }

            it { is_expected.to be_falsey }
          end

          context "changing address, including zip_code and province" do
            let(:params) { {:city => "Łódź", :street => "Mickiewicza 16/3", :country => "DE", :zip_code => "42-222", :province => "Mazowieckie" } }

            it { is_expected.to be_truthy }
          end

          context "changing phone" do
            let(:params) { {:phone => "+48.666666666"} }

            it { is_expected.to be_truthy }
          end

          context "changing fax" do
            let(:params) { {:phone => "+48.666666666"} }

            it { is_expected.to be_truthy }
          end

          context "changing email" do
            let(:params) { {:email => "jackob@gmail.com"} }

            it { is_expected.to be_truthy }
          end

          context "changing from person to company" do
            let(:params) { {:person => false, :publish => true} }

            it { is_expected.to be_falsey }
          end
        end

        context "when contact does not exist" do
          before { the_object.contact_delete(contact_id) }

          it { is_expected.to be_falsey }
        end
      end
    end
  end

  describe "contacts" do
    let(:login)    { login2 }
    let(:password) { password2 }
    let(:prefix)   { prefix2 }
    before { the_object.login(login, password) }
    subject { the_object.contacts }

    it {
      pending "need to record VCR"
      is_expected.to eq([
        "1359551872",
        "1359556580",
        "1359561091",
        "2",
        "1359632570",
        "1359989004",
        "1359991329",
        "1359991599",
        "1359992182",
        "1359994193",
        "1360000583",
        "1360071397",
        "1360071456",
        "1360071628",
        "1360071722",
        "1360071806",
        "11",
        "13",
        "14",
        "16",
        "4",
        "20",
        "21",
        "22",
        "23",
        "26",
        "28",
        "29",
        "30",
        "31",
        "38",
        "39",
        "40",
        "12",
        "41",
        "42",
        "43",
        "44",
        "45",
        "49",
        "55",
        "1",
        "9"
      ])
    }
  end

end
