class Item < ApplicationRecord
  extend Memoist

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

  def self.fist
    Item.new(name: 'Unarmed Strike', data: { 'formula' => 'PA*WP', 'xa' => 'PA' })
  end

  memoize def formula
    data['formula']
  end

  memoize def proc_formula
    data['proc_formula']
  end

  memoize def bow?
    proficiencies.map(&:record).include?(Skill.find_by(name: 'Equip Bows')) && data['flags'].match?(/2-hands only/i)
  end
  
  memoize def gun?
    proficiencies.map(&:record).include?(Skill.find_by(name: 'Equip Gun'))
  end

  memoize def magic_gun?
    gun? && formula.match?(/MA/)
  end

  memoize def spear?
    proficiencies.map(&:record).include?(Skill.find_by(name: 'Equip Spear'))
  end

  memoize def sword?
    proficiencies.map(&:record).include?(Skill.find_by(name: 'Equip Sword'))
  end

  memoize def katana?
    proficiencies.map(&:record).include?(Skill.find_by(name: 'Equip Katana'))
  end

  memoize def sword_or_katana?
    sword? || katana?
  end

  def data=(value)
    self[:data] = value.is_a?(String) ? JSON.parse(value) : value
  end
end
