require 'dotenv'
Dotenv.load

shared_context "accounts" do

  let(:login1)    { ENV['NASK_EPP_LOGIN1'] }
  let(:password1) { ENV['NASK_EPP_PASSWORD1'] }
  let(:prefix1)   { ENV['NASK_EPP_PREFIX1'] }

  let(:login2)    { ENV['NASK_EPP_LOGIN2'] }
  let(:password2) { ENV['NASK_EPP_PASSWORD2'] }
  let(:prefix2)   { ENV['NASK_EPP_PREFIX2'] }

end
