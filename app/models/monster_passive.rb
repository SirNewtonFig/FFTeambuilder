class MonsterPassive < ApplicationRecord
  belongs_to :job

  has_many :exclusions, as: :ability_a

  def memgen_id(_slot)
    data['memgen_id']
  end

  def data=(value)
    self[:data] = value.is_a?(String) ? JSON.parse(value) : value
  end
end
