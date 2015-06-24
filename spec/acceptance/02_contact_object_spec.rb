# coding: utf-8

require 'spec_helper'

#
#
# 2. Obiekt kontakt
#
#
describe "02_contact_object_registration", :vcr do

  include_context "accounts"
  include_context "contacts"

  before { cleanup }

  let(:nask) { Nask.new(login1, password1, prefix1) }
  let(:nask2) { Nask.new(login2, password2, prefix2) }

  let(:ns_domain_name) { "prostydns.pl" }
  let(:ns_domain_params) { {
    :name => domain_name,
    :period => 1,
    :contact => "#{prefix1}#{contact_id}",
    :registrant => "#{prefix1}#{contact_id}",
    :ns => [host_params1[:name], host_params2[:name]],
    :pw => "xxxxxxxx"
  } }

  let(:host_name1) { "ns1.prostydns.pl" }
  let(:host_params1) { {
    :name => host_name1,
    :ipv4 => ["31.186.86.138"]
  } }

  let(:host_name2) { "ns2.prostydns.pl" }
  let(:host_params2) { {
    :name => host_name2,
    :ipv4 => ["176.9.20.181"]
  } }

  let(:contact_id) { 214545116 }

  let(:domain_name) { "example#{contact_id}.pl" }
  let(:domain_params) { {
    :name => domain_name,
    :period => 1,
    :contact => "#{prefix1}#{contact_id}",
    :registrant => "#{prefix1}#{contact_id}",
    :ns => [host_params1[:name], host_params2[:name]],
    :pw => "yyyyyyyy#{contact_id}"
  } }

  #
  #2.1. Rejestracja obiektu kontakt <contact:create> (10 komend)
  #
  it "contact:create" do
    nask.login(login1, password1)

    #1. Zarejestruj 8 obiektów kontakt.
    expect(contact_create_1).to be_truthy
    expect(contact_create_2).to be_truthy
    expect(contact_create_3).to be_truthy
    expect(contact_create_4).to be_truthy
    expect(contact_create_5).to be_truthy
    expect(contact_create_6).to be_truthy
    expect(contact_create_7).to be_truthy
    expect(contact_create_8).to be_truthy

    #2. Zarejestruj 2 obiekty kontakt z identycznymi danymi.
    expect(contact_create_9).to be_truthy
    expect(contact_create_10).to be_truthy

    cleanup
  end

  #
  #2.2. Sprawdzenie dostępności obiektu kontakt <contact:check> (3 komendy)
  #
  it "contact:check" do
    nask.login(login1, password1)

    #1. Sprawdź dostępność jednego nieistniejącego w systemie obiektu kontakt.
    expect(nask.contact_check(contact_id)[contact_id]).to be_truthy

    expect(contact_create_1).to be_truthy
    #2. Sprawdź dostępność jednego istniejącego w systemie obiektu kontakt.
    expect(nask.contact_check(contact_id)[contact_id]).to be_falsey

    #3. Sprawdź za pomocą jednej komendy, dostępność dwóch obiektów kontakt w tym
    #jednego istniejącego i jednego nieistniejącego w systemie.
    check = nask.contact_check(contact_id, 1234182732)
    expect(check[contact_id]).to be_falsey
    expect(check[1234182732]).to be_truthy

    nask.contact_delete(contact_id)
    nask.contact_delete(1234182732)
  end

  #
  #2.3. Uzyskanie informacji o obiekcie kontakt <contact:info> (2 komendy)
  #
  describe "contact:info" do
    let(:contact_id) { 241145116 }
    # TODO: need to record VCR
    xit "contact_id=241145116 " do
      nask.login(login1, password1)
      expect(contact_create_1).to be_truthy

      #1. Pobierz informacje o istniejącym w systemie obiekcie kontakt,
      #   dla którego jesteś uprawnionym Registrarem.
      expect(nask.contact_info(contact_id)).to eq contact_data

      pending "need to record VCR"
      expect(nask.domain_create(domain_params)).to be_truthy
      roid = nask.domain_info(domain_name, :pw => domain_params[:pw])[:roid]

      nask.logout
      expect(nask2.login(login2, password2)).to be_truthy

      #2. Pobierz informacje o istniejącym w systemie obiekcie kontakt,
      #   dla którego nie jesteś uprawnionym Registrarem,
      #   ale posiadasz AutInfo do obiektu domena powiązanego z tym kontaktem.
      expect(
        nask2.contact_info(
          contact_id,
          :prefix => prefix1,
          :pw => domain_params[:pw],
          :roid => roid
        )
      ).to eq(contact_data)
      nask2.logout
    end
  end

  #
  #2.4. Zmiana danych obiektu kontakt <contact:update> (2 komendy)
  #
  it "contact:update" do
    nask.login(login1, password1)
    expect(contact_create_1).to be_truthy
    expect(contact_create_2).to be_truthy

    #1. Zmień dane adresowe dwóch obiektów kontakt, dla którego jesteś uprawnionym Registrarem.
    expect(
      nask.contact_update(contact_id, {:email => "user+new@example.com"})
    ).to be_truthy
    expect(
      nask.contact_update(2, {:email => "user+new2@example.com"})
    ).to be_truthy
  end

  #
  #2.5. Usunięcie obiektu kontakt <contact:delete> (2 komendy)
  #
  it "contact:delete" do
    nask.login(login1, password1)
    expect(contact_create_1).to be_truthy

    #1. Usuń 2 obiekty kontakt, dla których jesteś uprawnionym Registrarem.
    expect(nask.contact_delete(contact_id)).to be_truthy
  end

  def cleanup
    nask = Nask.new(login1, password1, prefix1) # zestawienie połączenia https
    nask.login(login1, password1)
    nask.domain_delete(domain_name)
    nask.contact_delete(contact_id)
    2.upto(10) do |n|
      nask.contact_delete(n)
    end
  end

end
