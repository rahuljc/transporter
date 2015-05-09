class RequesterPayment < ActiveRecord::Base
  belongs_to :request
  belongs_to :requester, :class_name => 'User'	
end
