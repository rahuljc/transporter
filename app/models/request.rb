class Request < ActiveRecord::Base
  belongs_to  :requester, :class_name => "User"
  belongs_to  :device

  STATUSUS = [
            [:open, 1],
            [:assigned, 2],
            [:picked_up, 3],
            [:delivered, 4]
          ]
  STATUS_BY_KEY = Hash[*STATUSUS.map{ |s| [s[0], s[1]] }.flatten]

  ERRORS = [
            [:access_denied, 1],
            [:delieverer_unavailable, 2],
            [:device_not_exist, 3],
            [:incorrect_password, 4]
          ]
  ERROR_BY_KEY = Hash[*ERRORS.map{ |s| [s[0], s[1]] }.flatten]
end
