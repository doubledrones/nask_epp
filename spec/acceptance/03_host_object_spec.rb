# coding: utf-8

require 'spec_helper'

#
#
# 3. Obiekt host
#
#
describe "03_host_object", :vcr do

  include_context "accounts"
  include_context "contacts"

  let(:nask) { Nask.new(login1, password1, prefix1) }
  let(:nask2) { Nask.new(login2, password2, prefix2) }

  let(:host_params2) { {
    :name => "ns2.prostydns.pl",
    :ipv4 => ["176.9.20.181"]
  } }

  let(:host_num) { 1332313219 }

  let(:ns_domain_name) { "prostydns.pl" }
  let(:ns_domain_params) { {
    :name => domain_name,
    :period => 1,
    :contact => "#{prefix1}#{contact_id}",
    :registrant => "#{prefix1}#{contact_id}",
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

  let(:domain_name) { "example#{host_num}.pl" }
  let(:domain_params) { {
    :name => domain_name,
    :period => 1,
    :contact => "#{prefix1}#{contact_id}",
    :registrant => "#{prefix1}#{contact_id}",
    :ns => [host_params1[:name], host_params2[:name]],
    :pw => "yyyyyyyy#{Time.now.to_i}"
  } }

  #
  #3.1. Rejestracja obiektu host <host:create> (10 komend)
  #
  it "host:create" do
    nask.login(login1, password1)

    #1. Zarejestruj 9 obiektów host.
    1.upto(9) do |n|
      expect(
        nask.host_create(
          :name => "host#{host_num+n}.example#{host_num}.pl",
          :ipv4 => ["176.9.20.181"]
        )
      ).to be_truthy
    end

    #2. Dokonaj próby rejestracji obiektu host juŜ istniejącego w systemie Registry.
    expect(
      nask.host_create(
        :name => "host#{host_num+1}.example#{host_num}.pl",
        :ipv4 => ["176.9.20.181"]
      )
    ).to be_falsey
  end

  #
  #3.2. Sprawdzenie dostępności obiektu host <host:check> (3 komendy)
  #
  it "host:check" do
    nask.login(login1, password1)
    expect(
      nask.host_create(
        :name => "host#{host_num+10}.example#{host_num}.pl",
        :ipv4 => ["176.9.20.181"]
      )
    ).to be_truthy

    #1. Sprawdź dostępność jednego nieistniejącego w systemie obiektu host.
    expect(
      nask.host_check("host#{host_num+11}.example#{host_num}.pl")
    ).to be_truthy

    #2. Sprawdź dostępność jednego istniejącego w systemie obiektu host.
    expect(
      nask.host_check("host#{host_num+10}.example#{host_num}.pl")
    ).to be_falsey

    #3. Sprawdź za pomocą jednej komendy, dostępność dwóch obiektów host w tym
    #jednego istniejącego i jednego nieistniejącego w systemie.
    check = nask.host_check(
      "host#{host_num+11}.example#{host_num}.pl",
      "host#{host_num+10}.example.pl"
    )
    expect(check["host#{host_num+11}.example#{host_num}.pl"]).to be_truthy
    expect(check["host#{host_num+10}.example#{host_num}.pl"]).to be_falsey
  end

  #
  #3.3. Uzyskanie informacji o obiekcie host <host:info> (2 komendy)
  #
  it "host:info" do
    nask.login(login1, password1)
    0.upto(1) do |n|
      expect(
        nask.host_create(
          :name => "host#{host_num+12+n}.example#{host_num}.pl",
          :ipv4 => ["176.9.20.181"]
        )
      ).to be_truthy
    end
    #1. Pobierz informacje o dwóch istniejących w systemie obiektach host.
    0.upto(1) do |n|
      expect(
        nask.host_info("host#{host_num+12+n}.example#{host_num}.pl")
      ).to eq(
        {
          :addr => "176.9.20.181",
          :name => "host#{host_num+12+n}.example#{host_num}.pl",
          :status => "pendingCreate"
        }
      )
    end
  end

  #
  #3.4. Zmiana danych obiektu host <host:update> (1 komenda)
  #
  it "host:change_addr" do
    nask.login(login1, password1)
    expect(
      nask.host_create(
        :name => "host#{host_num+14}.example#{host_num}.pl",
        :ipv4 => ["176.9.20.181"]
      )
    ).to be_truthy
    contact_create_1
    nask.host_create(host_params1)
    nask.host_create(host_params2)
    nask.domain_create(ns_domain_params)
    nask.domain_create(domain_params)

    #1. Zmień adres IP obiektu host.
    expect(
      nask.host_change_addr(
        "host#{host_num+14}.example#{host_num}.pl",
        "31.186.86.138"
      )
    ).to be_truthy
  end

  #
  #3.5. Usunięcie obiektu host <host:delete> (3 komendy)
  #
  describe "host:delete" do
    let(:domain_name) { "example#{host_num+1}.pl" }
    it "domain_name=?" do
      nask.login(login1, password1)
      0.upto(2) do |n|
        expect(
          nask.host_create(
            :name => "host#{host_num+15+n}.example#{host_num}.pl",
            :ipv4 => ["176.9.20.181"]
          )
        ).to be_truthy
      end
      contact_create_1
      nask.host_create(host_params1)
      nask.host_create(host_params2)
      nask.domain_create(ns_domain_params)
      nask.domain_create(domain_params)

      #1. Usuń 2 obiekty host, dla których jesteś uprawnionym Registrarem.
      #   Przed wykonaniem usunięcia obiektu host upewnij się,
      #   Ŝe posiada on status OK - został dowiązany do obiektu domena.
      0.upto(2) do |n|
        expect(
          nask.host_status_ok?("host#{host_num+15+n}.example#{host_num}.pl")
        ).to be_truthy
      end
      0.upto(1) do |n|
        expect(
          nask.host_delete("host#{host_num+15+n}.example#{host_num}.pl")
        ).to be_truthy
      end


      nask.logout
      nask2.login(login2, password2)

      #2. Dokonaj próby usunięcia obiektu host, dla którego nie jesteś uprawnionym Registrarem.
      expect(
        nask2.host_delete("host#{host_num+17}.example#{host_num}.pl")
      ).to be_falsey
    end
  end

end
