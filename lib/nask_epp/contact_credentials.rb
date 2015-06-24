class NaskEpp::ContactCredentials

  class Error < StandardError
  end

  POSTAL_ATTRIBUTES = [
    :name,
    :street,
    :city,
    :province,
    :zip_code,
    :country
  ]

  ATTRIBUTES = [
    :contact_id,
    :phone,
    :fax,
    :email,
    :person,
    :publish
  ] + POSTAL_ATTRIBUTES

  ATTRIBUTES.each do |attr|
    attr_reader attr
  end

  def initialize(options)
    ATTRIBUTES.each do |attr|
      instance_variable_set("@#{attr}", options[attr])
    end
  end

  def to_hash
    valid!
    Hash[
      *ATTRIBUTES.collect {|attr| [attr, send(attr)] }.flatten
    ]
  end

  private

    def validate_contact_id
      /^[a-zA-Z0-9_]+$/ =~ contact_id && 2 < contact_id.size && contact_id.size < 16
    end

    def validate_name
      validate_postal_info(name)
    end

    def validate_street
      validate_postal_info(street)
    end

    def validate_city
      validate_postal_info(city)
    end

    def validate_province
      validate_postal_info(province)
    end

    def validate_zip_code
      validate_postal_info(zip_code)
    end

    def validate_country
      validate_postal_info(country)
    end

    def validate_phone
      true # TODO
    end

    def validate_fax
      true # TODO
    end

    def validate_email
      true # TODO
    end

    def validate_person
      [true, false].include?(person)
    end

    def validate_publish
      [true, false].include?(publish)
    end

    def validate_postal_info(field)
      ['<', '>', '|', '[', ']', '{', '}', '#', '%', ';', "\\"].each do |forbidden_char|
        return false if field.include?(forbidden_char)
      end
    end

    def valid!
      ATTRIBUTES.each do |attr|
        raise Error, "#{attr} NOT VALID!" unless send("validate_#{attr}")
      end
    end

end
