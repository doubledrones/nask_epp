# coding: utf-8

require 'spec_helper'

#
#
# III. Scenariusze dla funkcjonalności Pre-Paid
#
#
describe "III_pre_paid_functionality_spec", :vcr do

  include_context "accounts"
  include_context "contacts"

  let(:num) { 1360072935 }

  let(:nask) { Nask.new(login1, password1, prefix1) }

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

  let(:domain_name) { "example123#{num}.prepaid.pl"}
  let(:domain_name2) { "example123#{num}-2.prepaid.pl"}

  describe "Sprawdzanie stanu rachunku prepaid" do
    let(:num) { 1461442935 }
    it "num=1461442935" do
      nask.login(login1, password1)
      #1. Sprawdź i zapamiętaj stan rachunku pre-paid.
      pending "need to record VCR"
      funds_before = nask.prepaid_payment_funds("domain")
      funds_before.should > 0

      #2. Sprawdź dostępność obiektu domena <name>.prepaid.pl.
      expect(nask.domain_check(domain_name)).to be_truthy

      #3. Zarezerwuj obiekt domena o nazwie <name>.prepaid.pl.
      contact_create_1
      nask.host_create(host_params1)
      nask.host_create(host_params2)
      nask.domain_create(ns_domain_params)
      expect(
        nask.domain_create(
          :name => domain_name,
          :ns => [host_params1[:name], host_params2[:name]],
          :pw => "yyyyyyyyxa#{num}",
          :book => true
        )
      ).to be_truthy

      #4. Zarejestruj obiekt domena o nazwie <name>.prepaid.pl.
      expect(
        nask.domain_create(
          :name => domain_name,
          :pw => "yyyyyyyyxa#{num}",
          :period => 1,
          :contact => "#{prefix1}#{contact_id}",
          :registrant => "#{prefix1}#{contact_id}",
          :reason => false
        )
      ).to be_truthy

      #5. Zarejestruj obiekt future <name>.prepaid.pl.
      expect(
        nask.future_create(:name => domain_name,
                           :period => 3,
                           :registrant => "#{prefix1}#{contact_id}",
                           :pw => "fyyyayxasdzz#{num}")
      ).to be_truthy

      #6. Sprawdź stan rachunku pre-paid i porównaj z poprzednią zapamiętaną wartością.
      funds_after = nask.prepaid_payment_funds("domain")
      funds_after.should < funds_before

      #7. Dokonaj odnowienia obiektu domena <name>.prepaid.pl.
      cur_exp_date = nask.domain_info(domain_name)[:exDate]
      expect(
        nask.domain_renew(
          domain_name, {:period => 1, :cur_exp_date => cur_exp_date}
        )
      ).to be_truthy

      #8. Dokonaj próby ponownej rezerwacji obiektu domena <name>.prepaid.pl.
      expect(
        nask.domain_create(
          :name => domain_name,
          :ns => [host_params1[:name], host_params2[:name]],
          :pw => "yyyyyyyyxa#{num}",
          :book => true
        )
      ).to be_falsey

      #9. Dokonaj próby ponownej rejestracji obiektu domena <name>.prepaid.pl.
      expect(
        nask.domain_create(
          :name => domain_name,
          :pw => "yyyyyyyyxa#{num}",
          :period => 1,
          :contact => "#{prefix1}#{contact_id}",
          :registrant => "#{prefix1}#{contact_id}",
        )
      ).to be_falsey

      #10. Dokonaj próby ponownej rejestracji obiektu future <name>.prepaid.pl.
      expect(
        nask.future_create(:name => domain_name,
                           :period => 3,
                           :registrant => "#{prefix1}#{contact_id}",
                           :pw => "fyyyayyyyyx#{num}")
      ).to be_falsey

      #11. Sprawdź stan rachunku pre-paid i porównaj z poprzednią zapamiętaną wartością.
      nask.prepaid_payment_funds("domain").should < funds_after
    end
  end

  describe "Mechanizm pobierania opłat" do
    let(:num) { 5543012935 }
    it "num=5543012935" do
      nask.login(login1, password1)
      #1. Sprawdź i zapamiętaj stan rachunku pre-paid.
      pending "need to record VCR"
      funds_before = nask.prepaid_payment_funds("domain")
      funds_before.should > 0

      #2. Sprawdź dostępność obiektu domena <name2>.prepaid.pl.
      expect(nask.domain_check(domain_name2)).to be_truthy

      #3. Zarejestruj obiekt test dla domeny o nazwie <name2>.prepaid.pl.
      contact_create_1
      nask.host_create(host_params1)
      nask.host_create(host_params2)
      nask.domain_create(ns_domain_params)
      expect(
        nask.domain_create(
          :name => domain_name2,
          :pw => "yyyyasda#{num}",
          :ns => [host_params1[:name], host_params2[:name]],
          :contact => "#{prefix1}#{contact_id}",
          :registrant => "#{prefix1}#{contact_id}",
          :taste => true
        )
      ).to be_truthy

      #4. Zarejestruj obiekt domena o nazwie <name2>.prepaid.pl.
      expect(
        nask.domain_create(
          :name => domain_name2,
          :pw => "yyyyasda#{num}",
          :period => 1,
          :reason => false
        )
      ).to be_truthy

      #5. Ustaw status clientRenewProhibited na obiekcie domena <name2>.prepaid.pl.
      expect(
        nask.domain_update(domain_name2, {:client_renew_prohibited => true})
      ).to be_truthy

      #6. Sprawdź stan rachunku pre-paid i porównaj z poprzednią zapamiętaną wartością.
      funds_after = nask.prepaid_payment_funds("domain")
      funds_after.should < funds_before

      #7. Dokonaj odnowienia obiektu domena <name2>.prepaid.pl.
      cur_exp_date = nask.domain_info(domain_name2)[:exDate]
      expect(
        nask.domain_renew(
          domain_name2, {:period => 1, :cur_exp_date => cur_exp_date}
        )
      ).to be_truthy

      #8. Dokonaj próby ponownego testu dla domeny <name2>.prepaid.pl.
      expect(
        nask.domain_create(
          :name => domain_name2,
          :pw => "yyyyasda#{num}",
          :ns => [host_params1[:name], host_params2[:name]],
          :contact => "#{prefix1}#{contact_id}",
          :registrant => "#{prefix1}#{contact_id}",
          :taste => true
        )
      ).to be_falsey

      #9. Dokonaj próby ponownej rejestracji obiektu domena <name2>.prepaid.pl.
      expect(
        nask.domain_create(
          :name => domain_name2,
          :pw => "yyyya#{num}",
          :ns => [host_params1[:name], host_params2[:name]],
          :period => 1,
          :contact => "#{prefix1}#{contact_id}",
          :registrant => "#{prefix1}#{contact_id}",
        )
      ).to be_falsey

      #10. Sprawdź stan rachunku pre-paid i porównaj z poprzednią zapamiętaną wartością.
      nask.prepaid_payment_funds("domain").should < funds_after
    end
  end

  describe "Mechanizm autoodnawiania domen" do
    let(:num) { 5275412935 }
    it "num=5275412935" do
      #    1. Zarejestruj obiekt domena o nazwie <name>-blocked.prepaid.pl.
      nask.login(login1, password1)
      contact_create_1
      nask.host_create(host_params1)
      nask.host_create(host_params2)
      nask.domain_create(ns_domain_params)
      expect(
        nask.domain_create(
          :name => "example123#{num}-blocked.prepaid.pl",
          :pw => "yyyyyyayyxa#{num}",
          :ns => [host_params1[:name], host_params2[:name]],
          :period => 1,
          :contact => "#{prefix1}#{contact_id}",
          :registrant => "#{prefix1}#{contact_id}",
        )
      ).to be_truthy
      #2. Zarejestruj obiekt domena o nazwie <name>-exp.prepaid.pl.
      expect(
        nask.domain_create(
          :name => "example123#{num}-exp.prepaid.pl",
          :pw => "yyyyaya#{num}",
          :ns => [host_params1[:name], host_params2[:name]],
          :period => 1,
          :contact => "#{prefix1}#{contact_id}",
          :registrant => "#{prefix1}#{contact_id}",
        )
      ).to be_truthy

      #3. Ustaw status clientRenewProhibited na obiekcie domena <name>-
      #blocked.prepaid.pl.
      expect(
        nask.domain_update(
          "example123#{num}-blocked.prepaid.pl",
          {:client_renew_prohibited => true}
        )
      ).to be_truthy

      #4. Sprawdź i zapamiętaj stan rachunku pre-paid.
      pending "need to record VCR"
      funds_before = nask.prepaid_payment_funds("domain")
      funds_before.should > 0

      #5. Zarejestrowana domena <name>-blocked.prepaid.pl wygaśnie i przejdzie w stan
      #Blocked o następnej pełnej godzinie, natomiast domena<name>-exp.prepaid.pl
      #zostanie po tym czasie odnowiona automatycznie.
      pending "after sleep it gives
      Failure/Error: funds_after.should < funds_before
     NameError:
       undefined method `<' for class `NilClass'"
      sleep(60*60)

      #6. Sprawdź stan rachunku pre-paid i porównaj z poprzednią zapamiętaną wartością.
      funds_after = nask.prepaid_payment_funds("domain")
      funds_after.should < funds_before
      funds_before = funds_after

      #7. Dokonaj reaktywacji zarejestrowanego obiektu domena <name>-
      #blocked.prepaid.pl.
      expect(
        nask.domain_renew(
          "example123#{num}-blocked.prepaid.pl",
          {:reactivate => true}
        )
      ).to be_truthy

      #8. Sprawdź stan konta pre-paid i porównaj z poprzednią zapamiętaną wartością.
      funds_after = nask.prepaid_payment_funds("domain")
      funds_after.should < funds_before
      funds_before = funds_after

      #UWAGA: Powiadomienia o stanie konta
      #1. Powiadom Zespół Rozwoju Programu Partnerskiego (ZRPP) NASK o ukończeniu testów scenariuszy nr 1 i 2. W systemie na twoim koncie zostaną dokonane następujące modyfikacje:
      #a) stan konta pre-paid zostanie zmieniony na X zł,
      #b) próg powiadamiania o kończących się środkach będzie wynosił Y zł.
      #2. Wykonaj taką ilość płatnych komend, aby pomniejszyć środki na swoim koncie
      #pre- paid do kwoty wskazanej w punkcie 1b.
      #3. Odbierz komunikat systemowy poll oraz powiadomienie wysłane na adres e-mail.
      #4. Wykonaj taką ilość płatnych komend, aby wyczerpać dostępne środki na swoim
      #koncie pre-paid.
      #5. Odbierz powiadomienie wysłane na adres e-mail.
    end
  end

end
