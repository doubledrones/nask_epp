# coding: utf-8

shared_context "contacts" do

  let(:contact_id) { Time.now.to_i }

  let(:name) { ENV['CONTACT1_NAME'] }
  let(:street) { ENV['CONTACT1_STREET'] }
  let(:city) { ENV['CONTACT1_CITY'] }
  let(:province) { ENV['CONTACT1_PROVINCE'] }
  let(:zip_code) { ENV['CONTACT1_ZIP_CODE'] }
  let(:country) { ENV['CONTACT1_COUNTRY'] }
  let(:phone) { ENV['CONTACT1_PHONE'] }
  let(:fax) { "" }
  let(:email) { ENV['CONTACT1_EMAIL'] }
  let(:person) { true }
  let(:publish) { true }

  let(:contact_data) { {
    :contact_id => contact_id,
    :name => name,
    :street => street,
    :city => city,
    :province => province,
    :zip_code => zip_code,
    :country => country,
    :phone => phone,
    :fax => fax,
    :email => email,
    :person => person,
    :publish => publish
  } }

  let(:contact_data2) { 
    contact_data.merge({
      :contact_id => 2,
      :name => ENV['CONTACT2_NAME'],
      :street => ENV['CONTACT2_STREET'],
      :phone => ENV['CONTACT2_PHONE'],
      :email => ENV['CONTACT2_EMAIL']
    })
  }

  let(:contact_1_email_password) { ENV['CONTACT_1_EMAIL_PASSWORD'] }
  let(:contact_create_1) { nask.contact_create(contact_data) }
  let(:contact_create_2) { nask.contact_create(contact_data2) }
  let(:contact_create_3) {
    nask.contact_create(
      :contact_id => 3,
      :name => ENV['CONTACT3_NAME'],
      :street => ENV['CONTACT3_STREET'],
      :city => ENV['CONTACT1_CITY'],
      :province => ENV['CONTACT1_PROVINCE'],
      :zip_code => ENV['CONTACT1_ZIP_CODE'],
      :country => ENV['CONTACT1_COUNTRY'],
      :phone => ENV['CONTACT3_PHONE'],
      :fax => "",
      :email => ENV['CONTACT3_EMAIL'],
      :person => true,
      :publish => true
    )
  }
  let(:contact_create_4) {
    nask.contact_create(
      :contact_id => 4,
      :name => ENV['CONTACT4_NAME'],
      :street => ENV['CONTACT4_STREET'],
      :city => ENV['CONTACT1_CITY'],
      :province => ENV['CONTACT1_PROVINCE'],
      :zip_code => ENV['CONTACT1_ZIP_CODE'],
      :country => ENV['CONTACT1_COUNTRY'],
      :phone => ENV['CONTACT4_PHONE'],
      :fax => "",
      :email => ENV['CONTACT4_EMAIL'],
      :person => true,
      :publish => true
    )
  }
  let(:contact_create_5) {
    nask.contact_create(
      :contact_id => 5,
      :name => ENV['CONTACT5_NAME'],
      :street => ENV['CONTACT5_STREET'],
      :city => ENV['CONTACT1_CITY'],
      :province => ENV['CONTACT1_PROVINCE'],
      :zip_code => ENV['CONTACT1_ZIP_CODE'],
      :country => ENV['CONTACT1_COUNTRY'],
      :phone => ENV['CONTACT5_PHONE'],
      :fax => "",
      :email => ENV['CONTACT5_EMAIL'],
      :person => true,
      :publish => true
    )
  }
  let(:contact_create_6) {
    nask.contact_create(
      :contact_id => 6,
      :name => ENV['CONTACT6_NAME'],
      :street => ENV['CONTACT1_STREET'],
      :city => ENV['CONTACT1_CITY'],
      :province => ENV['CONTACT1_PROVINCE'],
      :zip_code => ENV['CONTACT1_ZIP_CODE'],
      :country => ENV['CONTACT1_COUNTRY'],
      :phone => ENV['CONTACT1_PHONE'],
      :fax => "",
      :email => ENV['CONTACT6_EMAIL'],
      :person => true,
      :publish => true
    )
  }
  let(:contact_create_7) {
    nask.contact_create(
      :contact_id => 7,
      :name => ENV['CONTACT7_NAME'],
      :street => ENV['CONTACT2_STREET'],
      :city => ENV['CONTACT1_CITY'],
      :province => ENV['CONTACT1_PROVINCE'],
      :zip_code => ENV['CONTACT1_ZIP_CODE'],
      :country => ENV['CONTACT1_COUNTRY'],
      :phone => ENV['CONTACT2_PHONE'],
      :fax => "",
      :email => ENV['CONTACT7_EMAIL'],
      :person => true,
      :publish => true
    )
  }
  let(:contact_create_8) {
    nask.contact_create(
      :contact_id => 8,
      :name => ENV['CONTACT8_NAME'],
      :street => ENV['CONTACT3_STREET'],
      :city => ENV['CONTACT1_CITY'],
      :province => ENV['CONTACT1_PROVINCE'],
      :zip_code => ENV['CONTACT1_ZIP_CODE'],
      :country => ENV['CONTACT1_COUNTRY'],
      :phone => ENV['CONTACT3_PHONE'],
      :fax => "",
      :email => ENV['CONTACT8_EMAIL'],
      :person => true,
      :publish => true
    )
  }
  let(:contact_create_9) {
    nask.contact_create(
      :contact_id => 9,
      :name => ENV['CONTACT1_NAME'],
      :street => ENV['CONTACT1_STREET'],
      :city => ENV['CONTACT1_CITY'],
      :province => ENV['CONTACT1_PROVINCE'],
      :zip_code => ENV['CONTACT1_ZIP_CODE'],
      :country => ENV['CONTACT1_COUNTRY'],
      :phone => ENV['CONTACT1_PHONE'],
      :fax => "",
      :email => ENV['CONTACT9_EMAIL'],
      :person => true,
      :publish => true
    )
  }
  let(:contact_create_10) {
    nask.contact_create(
      :contact_id => 10,
      :name => ENV['CONTACT2_NAME'],
      :street => ENV['CONTACT2_STREET'],
      :city => ENV['CONTACT1_CITY'],
      :province => ENV['CONTACT1_PROVINCE'],
      :zip_code => ENV['CONTACT1_ZIP_CODE'],
      :country => ENV['CONTACT1_COUNTRY'],
      :phone => ENV['CONTACT2_PHONE'],
      :fax => "",
      :email => ENV['CONTACT2_EMAIL'],
      :person => true,
      :publish => true
    )
  }

end
