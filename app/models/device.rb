class Device < ActiveRecord::Base
  belongs_to  :user
  has_many    :requests
  has_one     :current_location, :dependent => :destroy
  has_one     :engaged_deliverer, :dependent => :destroy  
end
