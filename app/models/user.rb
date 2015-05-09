class User < ActiveRecord::Base
	acts_as_authentic do |c|
	  c.login_field(:email)
      c.validate_password_field(false)
      c.validate_email_field(false)
	end
end