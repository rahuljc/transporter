class EngagedDeliverer < ActiveRecord::Base
  belongs_to :device
  belongs_to :request
end
