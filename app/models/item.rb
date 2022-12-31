class Item < ApplicationRecord
  enum :item_type, %i{ weapon shield helmet armor accessory }
  # serialize :data, HashWithIndifferentAccess

  has_many :proficiencies
  has_many :jobs, through: :proficiencies, source: :record, source_type: 'Job'
  has_many :skills, through: :proficiencies, source: :record, source_type: 'Skill'

  scope :proficient, ->(char) {
    s = joins(:jobs).where(jobs: { id: char.data['job'].to_i })
      .union(joins(:skills).where(skills: { id: char.data['support'].to_i }))

    s = s.union(where("(data -> 'female_only') is not null")) if char.data['sex'] == 'f'

    s
  }

  scope :two_swords, -> {
    where("data ->> 'flags' ilike '%2-swords%'")
  }

  scope :two_hands, -> {
    where("data ->> 'flags' ilike '%2-hands%'")
  }

  scope :two_hands_only, -> {
    where("data ->> 'flags' ilike '%2-hands only%'")
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
        .where.not("data ->> 'flags' ilike '%2-hands only%'")
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
        .where.not("data ->> 'flags' ilike '%2-hands only%'")
    else
      none
    end
  }
end
