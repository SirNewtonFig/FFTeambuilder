class Item < ApplicationRecord
  enum :item_type, %i{ weapon shield helmet armor accessory }
  # serialize :data, HashWithIndifferentAccess

  has_many :proficiencies
  has_many :jobs, through: :proficiencies, source: :record, source_type: 'Job'
  has_many :skills, through: :proficiencies, source: :record, source_type: 'Skill'

  scope :proficient, ->(char) {
    s = joins(:jobs).where(jobs: { id: char.data['job'].to_i })
      .union(joins(:skills).where(skills: { id: char.rsm }))

    s = s.union(where("(items.data -> 'female_only')::boolean")) if char.data['sex'] == 'f'

    s
  }

  scope :two_swords, -> {
    where("items.data ->> 'flags' ilike '%2-swords%'")
  }

  scope :two_hands, -> {
    where("items.data ->> 'flags' ilike '%2-hands%'")
  }

  scope :two_hands_only, -> {
    where("items.data ->> 'flags' ilike '%2-hands only%'")
  }

  scope :rhand, ->(char) {
    if char.lhand.blank?
      weapon.proficient(char)
        .union(shield.proficient(char))
    elsif char.lhand.weapon? && !char.lhand&.data['flags']&.match?('2-hands only')
      s = shield.proficient(char)
      s = s.union(weapon.two_swords.proficient(char)) if char.two_swords? && char.lhand.data['flags']&.match?('2-swords')
      s
    elsif char.lhand.shield?
      weapon.proficient(char)
        .where("(items.data ->> 'flags') is null")
        .union(
          weapon.proficient(char)
            .where.not("items.data ->> 'flags' ilike '%2-hands only%'")
        )
    else
      none
    end
  }

  scope :lhand, ->(char) {
    if char.rhand.blank?
      weapon.proficient(char)
        .union(shield.proficient(char))
    elsif char.rhand.weapon? && !char&.rhand.data['flags']&.match?('2-hands only')
      s = shield.proficient(char)
      s = s.union(weapon.two_swords.proficient(char)) if char.two_swords? && char.rhand.data['flags']&.match?('2-swords')
      s
    elsif char.rhand.shield?
      weapon.proficient(char)
        .where.not("items.data ->> 'flags' ilike '%2-hands only%'")
    else
      none
    end
  }

  def formula
    data['formula']
  end

  def proc_formula
    data['proc_formula']
  end

  def gun?
    proficiencies.map(&:record).include?(Skill.find_by(name: 'Equip Gun'))
  end

  def spear?
    proficiencies.map(&:record).include?(Skill.find_by(name: 'Equip Spear'))
  end

  def sword?
    proficiencies.map(&:record).include?(Skill.find_by(name: 'Equip Sword'))
  end

  def katana?
    proficiencies.map(&:record).include?(Skill.find_by(name: 'Equip Katana'))
  end

  def sword_or_katana?
    sword? || katana?
  end

  def data=(value)
    self[:data] = value.is_a?(String) ? JSON.parse(value) : value
  end
end
