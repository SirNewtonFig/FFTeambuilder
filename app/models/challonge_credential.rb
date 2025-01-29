class ChallongeCredential < ApplicationRecord
  self.filter_attributes += [:username, :key]

  belongs_to :user
  
  encrypts :username
  encrypts :key
end
