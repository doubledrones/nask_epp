# coding: utf-8

require 'spec_helper'
require 'net/pop'

#
#
# II. Scenariusze dla obiektu future
#
#
describe "II_future_object", :vcr do

  include_context "accounts"
  include_context "contacts"

  let(:nask) { Nask.new(login1, password1, prefix1) }
  let(:nask_2) { Nask.new(login2, password2, prefix2) }

  let(:host_num) { 1363471950 }

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

  let(:domain_name) { "example#{host_num}.pl" }
  let(:domain_params) { {
    :name => domain_name,
    :period => 1,
    :contact => "#{prefix1}#{contact_id}",
    :registrant => "#{prefix1}#{contact_id}",
    :ns => [host_params1[:name], host_params2[:name]],
    :pw => "yyyyyyyy#{host_num}"
  } }

  let(:future_name) { domain_name }
  let(:future_params) { {
    :name => future_name,
    :period => 3,
    :registrant => "#{prefix1}#{contact_id}",
    :pw => "fyyyyyyyyyx#{host_num}"
  } }

  #
  #1. Rejestracja obiektu future <future:create> (5 komend)
  #
  describe "future:create" do
    let(:host_num) { 1143344365 }
    it "host_num=1143344365" do
      #1. Zaloguj się na konto 1.
      expect(nask.login(login1, password1)).to be_truthy

      #2. Zarejestruj 5 obiektów future, dla 5 istniejących w systemie obiektów domena,
      #które znajdują się w stanie REGISTERED.
      contact_create_1
      nask.host_create(host_params1)
      nask.host_create(host_params2)
      nask.domain_create(ns_domain_params)
      5.times do |i|
        expect(
          nask.domain_create(:name => "example#{host_num+i}.pl",
                             :period => 1,
                             :contact => "#{prefix1}#{contact_id}",
                             :registrant => "#{prefix1}#{contact_id}",
                             :ns => [host_params1[:name], host_params2[:name]],
                             :pw => "yyyyyyyyyyx#{host_num+i}")
        ).to be_truthy
        expect(
          nask.future_create(:name => "example#{host_num+i}.pl",
                             :period => 3,
                             :registrant => "#{prefix1}#{contact_id}",
                             :pw => "fyyyyyyyyyx#{host_num+i}")
        ).to be_truthy
      end
    end
  end

  #
  #2. Transfer obiektu future <future:transfer> (9 komend)
  #
  describe "future:transfer" do
    let(:host_num) { 2123434161 }
    it "host_num=2123434161" do
      #2. Zainicjuj transfer 4 obiektów future, utworzonych w poprzednim teście
      #(Rejestracja obiektu future) za pomocą komendy <future:transfer> z atrybutem op
      #o wartości request
      expect(nask.login(login1, password1)).to be_truthy
      contact_create_1
      nask.host_create(host_params1)
      nask.host_create(host_params2)
      nask.domain_create(ns_domain_params)
      4.times do |i|
        expect(
          nask.domain_create(:name => "example#{host_num+i}.pl",
                             :period => 1,
                             :contact => "#{prefix1}#{contact_id}",
                             :registrant => "#{prefix1}#{contact_id}",
                             :ns => [host_params1[:name], host_params2[:name]],
                             :pw => "yyyyyyyyyyx#{host_num+i}")
        ).to be_truthy
        expect(
          nask.future_create(:name => "example#{host_num+i}.pl",
                             :period => 3,
                             :registrant => "#{prefix1}#{contact_id}",
                             :pw => "fyyyyyyyyyx#{host_num+i}")
        ).to be_truthy
      end

      #1. Zaloguj się na konto 2.
      nask.logout
      expect(nask_2.login(login2, password2)).to be_truthy
      4.times do |i|
        expect(
          nask_2.future_transfer(
            "example#{host_num+i}.pl",
            {:op => "request", :pw => "fyyyyyyyyyx#{host_num+i}"}
          )
        ).to be_truthy
      end

      #3. Pobierz informacje o zainicjowanych transferach obiektów future za pomocą
      #komendy <future:transfer> z atrybutem op o wartości query.
      4.times do |i|
        expect(
          nask_2.future_transfer(
            "example#{host_num+i}.pl",
            {:op => "query", :pw => "fyyyyyyyyyx#{host_num+i}"}
          )
        ).to be_truthy
      end

      #4. Potwierdź transfer 2 obiektów future „klikając” adres URL otrzymany w
      #wiadomości e-mail wysłanej na adres kontaktu dowiązanego do obiektu future.
      #
      # 30.04.2013 goozzik Na potrzeby testu kliknołem ręcznie bo w skrzynce robi się bałagan i cięzko to skodować
      #
      # [0] Transfer succesfully executed (request ID: 6dca14bec1db942bf3458f279d28b10)
      # mail potwierdzający: [Test] example1143434163.pl - przeniesienie obsługi opcji na domenę / future transfer
      # [0] Transfer succesfully executed (request ID: 8513286088fd4628d36e326f3adbf6)
      # mail potwierdzający: [Test] example1143434164.pl - przeniesienie obsługi opcji na domenę / future transfer
      #
      #      Capybara.current_driver = :selenium
      #      [0, 2].each do |index|
      #        visit get_confirmation_link_from_mail(index)
      #        page.should have_content("Transfer succesfully executed")
      #      end

      #5. Usuń 2 pozostałe zainicjowane transfery obiektów future za pomocą komendy
      #<future:transfer> z atrybutem op o wartości cancel.
      2.times do |i|
        expect(
          nask_2.future_transfer(
            "example#{host_num+i}.pl",
            {:op => "cancel", :pw => "fyyyyyyyyyx#{host_num+i}"}
          )
        ).to be_truthy
      end
    end
  end

  #
  #3. Zmiana danych obiektu future <future:update> (2 komendy)
  #
  describe "future:update" do
    let(:host_num) { 2144634361 }
    it "host_num=2144634361" do
      nask.login(login1, password1)
      contact_create_1
      nask.host_create(host_params1)
      nask.host_create(host_params2)
      nask.domain_create(ns_domain_params)
      nask.domain_create(domain_params)
      nask.future_create(future_params)

      #1. Zaloguj się na konto 2.
      nask_2.login(login2, password2)
      expect(
        nask_2.future_transfer(
          future_name,
          {:op => "request", :pw => future_params[:pw]}
        )
      ).to be_truthy

      # 30.04.2013 goozzik Na potrzeby testu kliknołem ręcznie bo w skrzynce robi się bałagan i cięzko to skodować
      #
      # [0] Transfer succesfully executed (request ID: b1fe1cf264a251e7ec654804c11ac5)
      # mail: [Test] example6244634361.pl - zlecono przeniesienie obsługi opcji na domenę / future transfer request
      #
      #      visit get_confirmation_link_from_mail(0)
      #      page.should have_content("Transfer succesfully executed")
      #
      #
      #
      # 04.07.2013 goozzik linki potwierdzające przychodzące na email nie działają
      pending "linki potwierdzające przychodzące na email nie działają"

      #2. Zmień registranta dla 1 obiektu future.
      nask_2.contact_create(contact_data2)
      expect(
        nask_2.future_update(future_name, {:registrant => "#{prefix2}2"})
      ).to be_truthy

      #3. Zmień kod AuthInfo dla 1 obiektu future.
      expect(
        nask_2.future_update(future_name, {:pw => "asdasdqweqwe#{host_num}"})
      ).to be_truthy
    end
  end

  #
  #4. Uzyskanie informacji o obiekcie future <future:info> (10 komend)
  #
  describe "future:info" do
    let(:host_num) { 5144244321 }
    it "host_num=5144244321" do
      #1. Zaloguj się na konto 2.
      expect(nask_2.login(login2, password2)).to be_truthy

      #2. Pobierz informację o wszystkich obiektach future uprzednio utworzonych bez
      #podawania kodu AuthInfo.
      nask.login(login1, password1)
      contact_create_1
      nask.host_create(host_params1)
      nask.host_create(host_params2)
      nask.domain_create(ns_domain_params)
      2.times do |i|
        expect(
          nask.domain_create(:name => "example#{host_num+i}.pl",
                             :period => 1,
                             :contact => "#{prefix1}#{contact_id}",
                             :registrant => "#{prefix1}#{contact_id}",
                             :ns => [host_params1[:name], host_params2[:name]],
                             :pw => "yyyyyyyyyyx#{host_num+i}")
        ).to be_truthy
        expect(
          nask.future_create(:name => "example#{host_num+i}.pl",
                             :period => 3,
                             :registrant => "#{prefix1}#{contact_id}",
                             :pw => "fyyyyyyyyyx#{host_num+i}")
        ).to be_truthy
      end
      2.times do |i|
        expect(
          nask_2.future_transfer(
            "example#{host_num+i}.pl",
            {:op => "request", :pw => "fyyyyyyyyyx#{host_num+i}"}
          )
        ).to be_truthy
      end

      # 30.04.2013 goozzik Na potrzeby testu kliknołem ręcznie bo w skrzynce robi się bałagan i cięzko to skodować
      #
      # mail: [Test] example5144244361.pl - zlecono przeniesienie obsługi opcji na domenę / future transfer request
      # mail: [Test] example5144244362.pl - zlecono przeniesienie obsługi opcji na domenę / future transfer request
      #
      #
      #      [0, 2].each do |index|
      #        visit get_confirmation_link_from_mail(index)
      #        page.should have_content("Transfer succesfully executed")
      #      end
      #Po transferze future dostaje nowe hasło.
      #
      #
      # 04.07.2013 goozzik linki potwierdzające przychodzące na email nie działają
      pending "linki potwierdzające przychodzące na email nie działają"
      new_passwords = []
      2.times do |i|
        future_info = nask_2.future_info("example#{host_num+i}.pl")
        future_info[:name].should == "example#{host_num+i}.pl"
        new_passwords.push future_info[:pw]
      end

      #3. Zaloguj się na konto 1.
      # (już jest zalogowany)

      #4. Pobierz informację o wszystkich obiektach future uprzednio utworzonych podając
      #poprawny kod AuthInfo.
      2.times do |i|
        nask.future_info("example#{host_num+i}.pl", {:pw => new_passwords[i]})[:name].should == "example#{host_num+i}.pl"
      end
    end
  end

  #
  #5. Sprawdzenie dostępności obiektu future <future:check>
  #
  describe "future:check" do
    let(:host_num) { 5132134365 }
    it "host_num=5132134365" do
      #1. Sprawdź dostępność obiektu future dla 5 zarejestrowanych domen, dla których nie utworzono obiektu future.
      nask.login(login1, password1)
      contact_create_1
      nask.host_create(host_params1)
      nask.host_create(host_params2)
      nask.domain_create(ns_domain_params)
      5.times do |i|
        expect(
          nask.domain_create(:name => "exampleasdzxc#{host_num+i}.pl",
                             :period => 1,
                             :contact => "#{prefix1}#{contact_id}",
                             :registrant => "#{prefix1}#{contact_id}",
                             :ns => [host_params1[:name], host_params2[:name]],
                             :pw => "yyzyyyyyyyyx#{host_num+i}")
        ).to be_truthy
        expect(
          nask.future_check(
            "exampleasdzxc#{host_num+i}.pl"
          )["exampleasdzxc#{host_num+i}.pl"]
        ).to eq "true"
      end

      #2. Sprawdź dostępność obiektu future dla 5 zarejestrowanych domen, dla których utworzono obiekt future.
      5.times do |i|
        expect(
          nask.future_create(:name => "exampleasdzxc#{host_num+i}.pl",
                             :period => 3,
                             :registrant => "#{prefix1}#{contact_id}",
                             :pw => "fyyyyyyyyyx#{host_num+i}")
        ).to be_truthy
        expect(
          nask.future_check(
            "exampleasdzxc#{host_num+i}.pl"
          )["exampleasdzxc#{host_num+i}.pl"]
        ).to eq "false"
      end
    end
  end

  #
  #6. Odnowienie obiektu future <future:renew> (3 komendy)
  #
  describe "future:renew" do
    let(:host_num) { 9149444165 }
    it "host_num=9149444165" do
      #1. Zaloguj się na konto 1.
      nask.login(login1, password1)

      #2. Dokonaj odnowienia 1 obiektu future.
      contact_create_1
      nask.host_create(host_params1)
      nask.host_create(host_params2)
      nask.domain_create(ns_domain_params)
      nask.domain_create(domain_params)
      nask.future_create(future_params)
      cur_exp_date = nask.future_info(domain_name)[:exDate]
      renew_period = 3
      nask.future_renew(domain_name, { :cur_exp_date => cur_exp_date, :period => renew_period })

      #3. Sprawdź za pomocą komendy <future:info> czy odnowienie zostało wykonane
      #poprawnie.
      new_exp_date = (cur_exp_date[0..3].to_i + renew_period).to_s + cur_exp_date[4..9]
      nask.future_info(domain_name)[:exDate][0..9].should == new_exp_date
    end
  end

  #
  #7. Usunięcie obiektu future <future:delete> (2 komendy)
  #
  describe "future:delete" do
    let(:host_num) { 9144414365 }
    it "host_num=9144414365" do
      #1. Zaloguj się na konto 2.
      nask_2.login(login2, password2)

      #2. Usuń 2 obiekty future.
      nask_2.contact_create(contact_data2)
      nask_2.host_create(host_params1)
      nask_2.host_create(host_params2)
      nask_2.domain_create(ns_domain_params)
      2.times do |i|
        nask_2.domain_create(:name => "exampleasdzxc123#{host_num+i}.pl",
                           :period => 1,
                           :contact => "#{prefix2}#{contact_id}",
                           :registrant => "#{prefix2}#{contact_id}",
                           :ns => [host_params1[:name], host_params2[:name]],
                           :pw => "yyzyyyyyyxxyyx#{host_num+i}")
        nask_2.future_create(:name => "exampleasdzxc123#{host_num+i}.pl",
                           :period => 3,
                           :registrant => "#{prefix2}#{contact_id}",
                           :pw => "fyyyyyyyyzzzzyx#{host_num+i}")
        expect(
          nask_2.future_delete("exampleasdzxc123#{host_num+i}.pl")
        ).to be_truthy
      end
    end
  end

  def get_confirmation_link_from_mail(mail_index)
    sleep(10)
    Net::POP3.enable_ssl(OpenSSL::SSL::VERIFY_NONE)
    pop = Net::POP3.start('pop.gmail.com', 995, email, contact_1_email_password)
    mail = pop.mails[-1 - mail_index].pop
    link_start_char = mail =~ /http:\/\/qregistry/
    link_section = mail[link_start_char..link_start_char+200]
    link_section.sub!("=\r\n", '')
    link_section.sub!("3D", '')
    link_end_char = (link_section =~ /\r/) - 1
    link_section[0..link_end_char]
  end

end
