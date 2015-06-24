# coding: utf-8

require 'spec_helper'

#
#
# 4. Obiekt domena
#
#
describe "04_domain_object", :vcr do

  include_context "accounts"
  include_context "contacts"

  before { cleanup }

  let(:nask) { Nask.new(login1, password1, prefix1) }
  let(:nask_2) { Nask.new(login2, password2, prefix2) }

  let(:host_num) { 1454637766 }

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

  let(:domain_1_name) { "exampledomain#{host_num+1}.pl" }
  let(:domain_1_params_with_book) { {
    :name => domain_1_name,
    :ns => [host_params1[:name], host_params2[:name]],
    :pw => "yyyyyyyy#{host_num+1}",
    :book => true
  } }

  let(:domain_1_params_without_book) { {
    :name => domain_1_name,
    :period => 1,
    :contact => "#{prefix1}#{contact_id}",
    :registrant => "#{prefix1}#{contact_id}",
    :ns => [host_params1[:name], host_params2[:name]],
    :pw => domain_1_params_with_book[:pw]
  } }

  let(:domain_2_name) { "exampledomain#{host_num+2}.pl" }
  let(:domain_2_params_with_book) { {
    :name => domain_2_name,
    :ns => [host_params1[:name], host_params2[:name]],
    :pw => "yyyyyyyy#{host_num+2}",
    :book => true
  } }

  let(:domain_2_params_without_book) { {
    :name => domain_2_name,
    :period => 1,
    :contact => "#{prefix1}#{contact_id}",
    :registrant => "#{prefix1}#{contact_id}",
    :ns => [host_params1[:name], host_params2[:name]],
    :pw => domain_2_params_with_book[:pw]
  } }

  let(:domain_3_name) { "exampledomain#{host_num+3}.pl" }
  let(:domain_3_params_with_book) { {
    :name => domain_3_name,
    :ns => [host_params1[:name], host_params2[:name]],
    :pw => "yyyyyyyy#{host_num+3}",
    :book => true
  } }

  let(:domain_3_params_without_book) { {
    :name => domain_3_name,
    :period => 1,
    :contact => "#{prefix1}#{contact_id}",
    :registrant => "#{prefix1}#{contact_id}",
    :ns => [host_params1[:name], host_params2[:name]],
    :pw => domain_3_params_with_book[:pw]
  } }

  #
  #4.1. Rezerwacja obiektu domena <domain:create> + <book> (3 komendy)
  #
  describe "domain:create + book" do
    let(:host_num) { 1532637766 }
    it "host_num=1532637766" do
      #1. Zaloguj się na konto 1.
      expect(nask.login(login1, password1)).to be_truthy

      #2. Zarezerwuj 3 obiekty domena.
      contact_create_1
      nask.host_create(host_params1)
      nask.host_create(host_params2)
      nask.domain_create(ns_domain_params)

      pending "need to record VCR"
      expect(nask.domain_create(domain_1_params_with_book)).to be_truthy
      expect(nask.domain_create(domain_2_params_with_book)).to be_truthy
      expect(nask.domain_create(domain_3_params_with_book)).to be_truthy
    end
  end

  #
  #4.2. Rejestracja obiektu domena <domain:create> (40 komend)
  #
  #TODO
  describe "domain:create" do
    let(:host_num) { 1333137766 }
    it "host_num=1333137766" do
      #1. Zaloguj się na konto 1.
      expect(nask.login(login1, password1)).to be_truthy

      #2. Zarejestruj 2 obiekty domena, które zostały zarezerwowane w poprzednim teście(4.1.).
      contact_create_1
      nask.host_create(host_params1)
      nask.host_create(host_params2)
      nask.domain_create(ns_domain_params)
      pending "need to record VCR"
      expect(nask.domain_create(domain_2_params_with_book)).to be_truthy
      expect(nask.domain_create(domain_3_params_with_book)).to be_truthy
      expect(
        nask.domain_create(
          :name => domain_2_name,
          :period => 1,
          :contact => "#{prefix1}#{contact_id}",
          :registrant => "#{prefix1}#{contact_id}",
          :pw => domain_2_params_with_book[:pw],
          :reason => false
        )
      ).to be_truthy
      expect(
        nask.domain_create(
          :name => domain_3_name,
          :period => 1,
          :contact => "#{prefix1}#{contact_id}",
          :registrant => "#{prefix1}#{contact_id}",
          :pw => domain_3_params_with_book[:pw],
          :reason => false
        )
      ).to be_truthy

      #3. Zarejestruj 31 obiekty domena, przypisując im róŜne okresy ich utrzymania (1-10
      #lat), kiedy obiekty kontakt i host juŜ istnieją w systemie.
      31.times do |i|
        expect(
          nask.domain_create(:name => "example#{host_num+i}.pl",
                             :period => rand(10)+1,
                             :contact => "#{prefix1}#{contact_id}",
                             :registrant => "#{prefix1}#{contact_id}",
                             :ns => [host_params1[:name], host_params2[:name]],
                             :pw => "yyyyyy#{host_num+i}")
        ).to be_truthy
      end

      #4. Zarejestruj 5 obiektów domena, kiedy obiekt kontakt istnieje, a obiekt host
      #znajduje się w stanie pendingCreate, (patrz komenda <host:info>) i w nazwie
      #obiektu host jest nazwa rejestrowanego obiektu domena.
      5.times do |i|
        nask.host_create(:name => "example4-2-4#{host_num+i}-1.example4-2-4#{host_num+i}.pl", :ipv4 => ["176.9.20.181"])
        nask.host_create(:name => "example4-2-4#{host_num+i}-2.example4-2-4#{host_num+i}.pl", :ipv4 => ["31.186.86.138"])
        nask.host_info("example4-2-4#{host_num+i}-1.example4-2-4#{host_num+i}.pl")[:status].should == "pendingCreate"
        nask.host_info("example4-2-4#{host_num+i}-2.example4-2-4#{host_num+i}.pl")[:status].should == "pendingCreate"
        expect(
          nask.domain_create(:name => "example4-2-4#{host_num+i}.pl",
                             :period => 1,
                             :contact => "#{prefix1}#{contact_id}",
                             :registrant => "#{prefix1}#{contact_id}",
                             :ns => ["example4-2-4#{host_num+i}-1.example4-2-4#{host_num+i}.pl",
                                     "example4-2-4#{host_num+i}-2.example4-2-4#{host_num+i}.pl"],
                             :pw => "yyyyyyyyyyyyy#{host_num+i}")
          ).to be_truthy
      end

      #5. Zarejestruj 1 obiekt domena, i wydeleguj go na minimum 4 obiekty host.
      nask.domain_create(domain_1_params_without_book).is_expected.to be_truthy
      nask.host_create(:name => "exampleeeeeee1.exampleexampleex#{host_num}.pl", :ipv4 => ["176.9.20.181"])
      nask.host_create(:name => "exampleeeeeee2.exampleexampleex#{host_num}.pl", :ipv4 => ["176.9.20.181"])
      expect(
        nask.domain_create(
          :name => "exampleexampleex#{host_num}.pl",
          :period => 1,
          :contact => "#{prefix1}#{contact_id}",
          :registrant => "#{prefix1}#{contact_id}",
          :ns => [host_params1[:name], host_params2[:name],
                  "exampleeeeeee1.exampleexampleex#{host_num}.pl", "exampleeeeeee2.exampleexampleex#{host_num}.pl"],
          :pw => "xxxxxxxxxxxxx#{host_num}"
        )
      ).to be_truthy

      #6. Dokonaj próby rejestracji obiektu domena delegowanego na obiekt host,
      #podrzędny do domeny (host zawierający nazwę rejestrowanej domeny), kt
      #óry wygasł po upływie dozwolonego czasu pozwalającego delegować (dowiązać) go do rejestrowanego obiektu domena.
      #TODO
      pending "Dokonaj próby rejestracji obiektu domena delegowanego na obiekt host,
      #podrzędny do domeny (host zawierający nazwę rejestrowanej domeny), kt
      #óry wygasł po upływie dozwolonego czasu pozwalającego delegować (dowiązać) go do rejestrowanego obiektu domena."
      #TODO Ile wynosi ten czas?
    end
  end

  #
  #4.3. Sprawdzenie dostępności obiektu domena <domain:check> (3 komendy)
  #
  describe "domain:check" do
    let(:host_num) { 1344137766 }
    it "host_num=1344137766" do
      nask.login(login1, password1)

      #1. Sprawdź dostępność jednego nieistniejącego w systemie obiektu domena.
      not_existing_domain = "napewnonieistnieje123123123123111.pl"
      expect(nask.domain_check(not_existing_domain)).to be_truthy

      #2. Sprawdź dostępność jednego istniejącego w systemie obiektu domena.
      expect(nask.domain_check("wp.pl")).to be_falsey

      #3. Sprawdź za pomocą jednej komendy, dostępność dwóch obiektów domena w tym
      #jednego istniejącego i jednego nieistniejącego w systemie.
      multiple_check = nask.domain_check(not_existing_domain, "wp.pl")
      expect(multiple_check[not_existing_domain]).to be_truthy
      expect(multiple_check["wp.pl"]).to be_falsey
    end
  end

  #
  #4.4. Uzyskanie informacji o obiekcie domena <domain:info> (2 komendy)
  #
  describe "domain:info" do
    let(:host_num) { 1222137766 }
    it "host_num=1222137766" do
      nask.login(login1, password1)

      #1. Pobierz informacje o istniejącym w systemie obiekcie domena, dla którego jesteś uprawnionym Registrarem.
      contact_create_1
      nask.host_create(host_params1)
      nask.host_create(host_params2)
      nask.domain_create(ns_domain_params)
      nask.domain_create(domain_2_params_without_book)
      pending "need to record VCR"
      expect(
        nask.domain_info(
          domain_2_params_without_book[:name],
          {:pw => domain_2_params_without_book[:pw]}
        )[:name]
      ).to eq domain_2_params_without_book[:name]

      #2. Zaloguj się na konto 2.
      nask.logout
      expect(nask_2.login(login2, password2)).to be_truthy

      #3. Pobierz informacje o istniejącym w systemie obiekcie domena, dla którego nie jesteś uprawnionym Registrarem ale posiadasz AutInfo do tego obiektu.
      expect(nask_2.domain_info(
        domain_2_params_without_book[:name],
        {:pw => domain_2_params_without_book[:pw]}
      )[:name]).to eq domain_2_params_without_book[:name]
    end
  end

  #
  #4.5. Edycja obiektu domena <domain:update>
  #
  describe "domain:update" do
    let(:host_num) { 1432134766 }
    it "host_num=1432134766" do
      nask.login(login1, password1)

      #4.5.1 Zmiana delegacji (8 komend)
      #1. Zmień delegację 8 obiektów domena, dla których jesteś uprawnionym Registrarem.
      contact_create_1
      nask.host_create(host_params1)
      nask.host_create(host_params2)
      nask.domain_create(ns_domain_params)
      8.times do |i|
        nask.host_create(
          :name => "example4-2-4#{host_num+i}-1.exampleexample#{host_num+i}.pl",
          :ipv4 => ["176.9.20.181"]
        )
        nask.host_create(
          :name => "example4-2-4#{host_num+i}-2.exampleexample#{host_num+i}.pl",
          :ipv4 => ["176.9.20.181"]
        )
        nask.domain_create(
          :name => "exampleexample#{host_num+i}.pl",
          :period => 1,
          :contact => "#{prefix1}#{contact_id}",
          :registrant => "#{prefix1}#{contact_id}",
          :ns => [host_params1[:name], host_params2[:name]],
          :pw => "xxxxxxxx"
        )
        nask.domain_create(
          :name => "exampleexample#{host_num+i}.pl",
          :period => 1,
          :contact => "#{prefix1}#{contact_id}",
          :registrant => "#{prefix1}#{contact_id}",
          :ns => [host_params1[:name], host_params2[:name]],
          :pw => "yyyyyyyyyyyy#{host_num+i}"
        )
        pending "need to record VCR"
        expect(
          nask.domain_update(
            "exampleexample#{host_num+i}.pl",
            {
              :ns_rem => [host_params1[:name], host_params2[:name]],
              :ns_add => [
                "example4-2-4#{host_num+i}-1.exampleexample#{host_num+i}.pl",
                "example4-2-4#{host_num+i}-2.exampleexample#{host_num+i}.pl"
              ]
            }
          )
        ).to be_truthy
      end

      #4.5.2. Zmiana AuthInfo (2 komendy)
      #1. Zmień AuthInfo 2 obiektów domena, dla których jesteś uprawnionym Registrarem.
      nask.domain_create(domain_2_params_without_book)
      expect(
        nask.domain_update(domain_2_name, {:pw => Time.now.to_i})
      ).to be_truthy
      nask.domain_create(domain_3_params_without_book)
      expect(
        nask.domain_update(domain_3_name, {:pw => Time.now.to_i})
      ).to be_truthy

      #4.5.3. Zmiana statusu (4 komendy)
      #1. Dodaj do 2 obiektów domena, dla których jesteś uprawnionym Registrarem, status clientUpdateProhibited.
      expect(
        nask.domain_update(domain_2_name, {:client_update_prohibited => true})
      ).to be_truthy
      expect(
        nask.domain_update(domain_3_name, {:client_update_prohibited => true})
      ).to be_truthy

      #2. Usuń status clientUpdateProhibited dla 2 obiektów domena, dla których został wcześniej ustawiony ten status.
      expect(
        nask.domain_update(domain_2_name, {:client_update_prohibited => false})
      ).to be_truthy
      expect(
        nask.domain_update(domain_3_name, {:client_update_prohibited => false})
      ).to be_truthy
    end
  end

  #
  #4.6. Usunięcie obiektu domena <domain:delete> (3 komendy)
  #
  describe "domain:delete" do
    let(:host_num) { 1532534765 }
    it "host_num=1532534765" do
      nask.login(login1, password1)

      #1. Usuń 3 obiekty domena, dla których jesteś uprawnionym Registrarem.
      contact_create_1
      nask.host_create(host_params1)
      nask.host_create(host_params2)
      nask.domain_create(ns_domain_params)
      pending "need to record VCR"
      nask.domain_create(domain_1_params_without_book)
      nask.domain_create(domain_2_params_without_book)
      nask.domain_create(domain_3_params_without_book)
      expect(nask.domain_delete(domain_1_name)).to be_truthy
      expect(nask.domain_delete(domain_2_name)).to be_truthy
      expect(nask.domain_delete(domain_3_name)).to be_truthy
    end
  end

  #
  #4.7. Transfer obiektu domena <domain:transfer> (5 komend)
  #
  describe "domain:transfer" do
    let(:host_num) { 1632534765 }
    it "host_num=1632534765" do
      nask.login(login1, password1)
      contact_create_1
      nask.host_create(host_params1)
      nask.host_create(host_params2)
      nask.domain_create(ns_domain_params)
      5.times do |i|
        nask.domain_create(
          :name => "example#{host_num+i}.pl",
          :period => 1,
          :contact => "#{prefix1}#{contact_id}",
          :registrant => "#{prefix1}#{contact_id}",
          :ns => [host_params1[:name], host_params2[:name]],
          :pw => "yyyyyyyyy#{host_num+i}"
        )
      end

      #1. Zaloguj się na konto 2.
      nask.logout
      expect(nask_2.login(login2, password2)).to be_truthy
      #2. Zainicjuj transfer dla 5 obiektów domena (utworzonych odpowiednio wcześniej na koncie 1 - zw
      #róć uwagę na wartość parametru TRANSFER PERIOD PROHIBITED) za pomocą komendy <domain:transfer> z atr
      #ybutem op o wartości request.
      pending "cannot transfer domain to early."
      5.times do |i|
        expect(
          nask_2.domain_transfer(
            "example#{host_num+i}.pl",
            { :pw => "yyyyyyyyy#{host_num+i}", :op => "request" }
          )
        ).to be_truthy
      end
      #TODO rest of spec
    end
  end

  def cleanup
    nask = Nask.new(login1, password1, prefix1) # zestawienie połączenia https
    nask.login(login1, password1)
    nask.domain_delete(domain_1_name)
    nask.domain_delete(domain_2_name)
    nask.domain_delete(domain_3_name)
  end

end
