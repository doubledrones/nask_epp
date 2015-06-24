require 'spec_helper'

#
#
# 1. Dostęp i zarządzanie hasłem
#
#
describe "01_access_and_password_management", :vcr do

  include_context "accounts"

  before { cleanup }

  #
  #1.1 Logowanie <login>
  #
  it "login" do
    nask = Nask.new(login1, password1, prefix1) # zestawienie połączenia https

    #1. UŜyj komendy <hello>.
    expect(nask.hello).to be_truthy

    #2. Zaloguj się na konto 1.
    expect(nask.login(login1, password1)).to be_truthy

    #3. Wyloguj się z systemu Registry.
    nask.logout #TODO .is_expected.to be_truthy

    #4. Ponownie zaloguj się na konto 1.
    expect(nask.login(login1, password1)).to be_truthy

    #5. Zaczekaj, aŜ system automatycznie wyloguje Registrara
    #   (autologout - timeout sesji określony jest parametrami Registry).
    puts "TODO: wait 30 minutes"
    #sleep 3600*30
    #nask


    #6. Powtórz kroki 1-5 dla drugiego posiadanego konta.
    nask2 = Nask.new(login2, password2, prefix2) # zestawienie połączenia https

    #6.#1. UŜyj komendy <hello>.
    expect(nask2.hello).to be_truthy

    #6.#2. Zaloguj się na konto 1.
    expect(nask2.login(login2, password2)).to be_truthy

    #6.#3. Wyloguj się z systemu Registry.
    nask2.logout #TODO .is_expected.to be_truthy

    #6.#4. Ponownie zaloguj się na konto 2.
    expect(nask2.login(login2, password2)).to be_truthy

    #6.#5. Zaczekaj, aŜ system automatycznie wyloguje Registrara
    #      (autologout - timeout sesji określony jest parametrami Registry).
    puts "TODO: wait 30 minutes"
    #sleep 3600*30
    #nask
  end

  #
  #1.2. Zmiana hasła w systemie
  #
  it "password change" do
    nask = Nask.new(login1, password1, prefix1) # zestawienie połączenia https

    #1. Wyloguj się z obecnej sesji.
    nask.logout

    #2. Zaloguj się na konto 1, zmieniając jednocześnie hasło do systemu Registry.
    expect(nask.change_password(login1, password1, password2)).to be_truthy

    #3. Zaloguj się do systemu za pomocą nowego hasła.
    expect(nask.login(login1, password2)).to be_truthy


    #4. Powtórz kroki 1-3 dla drugiego posiadanego konta.
    nask2 = Nask.new(login2, password2, prefix2) # zestawienie połączenia https

    #4.#1. Wyloguj się z obecnej sesji.
    nask2.logout #TODO .is_expected.to be_truthy

    #4.#2. Zaloguj się na konto 2, zmieniając jednocześnie hasło do systemu Registry.
    expect(nask2.change_password(login2, password2, password1)).to be_truthy

    #4.#3. Zaloguj się do systemu za pomocą nowego hasła.
    expect(nask2.login(login2, password1)).to be_truthy

    cleanup
  end

  def cleanup
    nask = Nask.new(login1, password1, prefix1) # zestawienie połączenia https
    nask.logout
    nask.change_password(login1, password2, password1)
    nask2 = Nask.new(login2, password2, prefix1) # zestawienie połączenia https
    nask2.logout
    nask2.change_password(login2, password1, password2)
  end

end
