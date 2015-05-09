class User < ActiveRecord::Base
	acts_as_authentic do |c|
	  c.login_field(:email)
      c.validate_password_field(false)
      c.validate_email_field(false)
	end

  ERROR_CODES = [
                [:cannot_be_nil, "1"],
                [:already_exist, "2"],
                [:cannot_be_changed, "3"]
                ]
  ERROR_CODE_BY_KEY = Hash[*ERROR_CODES.map{ |s| [s[0], s[1]] }.flatten]
  
  def validate_user
    errors.add(:first_name, ERROR_CODE_BY_KEY[:cannot_be_nil]) if first_name.nil?
    errors.add(:last_name, ERROR_CODE_BY_KEY[:cannot_be_nil]) if last_name.nil?
    errors.add(:vehicle_number, ERROR_CODE_BY_KEY[:cannot_be_nil]) if self.deliverer and vehicle_number.nil?
    errors.add(:email, ERROR_CODE_BY_KEY[:cannot_be_nil]) if email.nil?
    errors.add(:phone_number, ERROR_CODE_BY_KEY[:cannot_be_nil]) if phone_number.nil?

    if self.new_record?
      errors.add(:email, ERROR_CODE_BY_KEY[:already_exist]) if User.find_by_email(email)
      errors.add(:phone_number, ERROR_CODE_BY_KEY[:already_exist]) if User.find_by_phone_number(phone_number)
      errors.add(:vehicle_number, ERROR_CODE_BY_KEY[:already_exist]) if deliverer and User.find_by_vehicle_number(vehicle_number)
    else
      errors.add(:email, ERROR_CODE_BY_KEY[:cannot_be_changed]) if self.email_changed?
      errors.add(:phone_number, ERROR_CODE_BY_KEY[:cannot_be_changed]) if self.phone_number_changed?
      errors.add(:deliverer, ERROR_CODE_BY_KEY[:cannot_be_changed]) if self.deliverer_changed?
    end
  end	
end