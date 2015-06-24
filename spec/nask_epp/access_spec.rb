require 'spec_helper'

describe NaskEpp::Access, :vcr do

  include_context "accounts"

  let(:the_class) { Nask }
  let(:the_object) { the_class.new(login, password, prefix) }

  describe "hello" do
    subject { the_object.hello }

    describe "first account" do
      let(:login)    { login1 }
      let(:password) { password1 }
      let(:prefix)   { prefix1 }

      it { is_expected.to be_truthy }
    end

    describe "second account" do
      let(:login)    { login2 }
      let(:password) { password2 }
      let(:prefix)   { prefix2 }

      it { is_expected.to be_truthy }
    end
  end

  describe "login" do
    subject { the_object.login(login, password) }

    describe "first account" do
      let(:login)    { login1 }
      let(:password) { password1 }
      let(:prefix)   { prefix1 }

      it { is_expected.to be_truthy }
    end

    describe "second account" do
      let(:login)    { login2 }
      let(:password) { password2 }
      let(:prefix)   { prefix2 }

      it { is_expected.to be_truthy }
    end

    describe "invalid login credentials" do
      let(:login)    { login1 }
      let(:password) { password1 }
      let(:prefix)   { prefix1 }

      subject { the_object.login("login", "password") }

      it { is_expected.to be_falsey }
    end
  end

  describe "change_password" do
    describe "first account" do
      let(:login)    { login1 }
      let(:password) { password1 }
      let(:prefix)   { prefix1 }
      let(:new_password) { "new_password" }

      it "should successfully change password and change it back" do
        expect(
          the_object.change_password(login, password, new_password)
        ).to be_truthy
        the_object.logout
        expect(
          the_object.change_password(login, new_password, password)
        ).to be_truthy
      end
    end

    describe "second account" do
      let(:login)    { login2 }
      let(:password) { password2 }
      let(:prefix)   { prefix2 }

      let(:new_password) { "new_password" }

      it "should successfully change password and change it back" do
        expect(
          the_object.change_password(login, password, new_password)
        ).to be_truthy
        the_object.logout
        expect(
          the_object.change_password(login, new_password, password)
        ).to be_truthy
      end
    end

    describe "invalid login credentials" do
      let(:login)    { login1 }
      let(:password) { password1 }
      let(:prefix)   { prefix1 }

      it "should not allow to change password" do
        expect(
          the_object.change_password("login", "password", "new_password")
        ).to be_falsey
      end
    end
  end

  describe "logout" do
    subject { the_object.logout }

    context "when not logged in" do
      describe "first account" do
      let(:login)    { login1 }
      let(:password) { password1 }
      let(:prefix)   { prefix1 }

        it { is_expected.to be_falsey }
      end

      describe "second account" do
      let(:login)    { login2 }
      let(:password) { password2 }
      let(:prefix)   { prefix2 }

        it { is_expected.to be_falsey }
      end
    end

    context "when logged in" do
      before { the_object.login(login, password) }

      describe "first account" do
      let(:login)    { login1 }
      let(:password) { password1 }
      let(:prefix)   { prefix1 }

        it { is_expected.to be_truthy }
      end

      describe "second account" do
      let(:login)    { login2 }
      let(:password) { password2 }
      let(:prefix)   { prefix2 }

        it { is_expected.to be_truthy }
      end
    end
  end

end
