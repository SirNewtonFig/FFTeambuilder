class Exclusion < ApplicationRecord
  belongs_to :ability_a, polymorphic: true
  belongs_to :ability_b, polymorphic: true
end
