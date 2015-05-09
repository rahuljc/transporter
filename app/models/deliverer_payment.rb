class DelivererPayment < ActiveRecord::Base
  belongs_to :request
  belongs_to :deliverer, :class_name => 'User'	
end
