class MonsterPassive < ApplicationRecord
  belongs_to :job

  has_many :exclusions, as: :ability_a
end
