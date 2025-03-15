class Skill < ApplicationRecord
  enum :skill_type, %i{ action reaction support movement }
  # serialize :data, HashWithIndifferentAccess

  belongs_to :job, optional: true
  has_many :proficiencies, as: :record, dependent: :destroy

  scope :valid, ->(char) {
    s = joins(:job).merge(Job.valid(char))
    s = s.where('1=0') unless char.can_equip_skills?

    s
  }

  scope :unique, ->(char, team) {
    generic_skills = []
    reactions = []

    (team.characters - [char]).each { |c|
      if c.generic?
        generic_skills  += [c.data['support'], c.data['movement'], *c.primary_skill_ids, *c.secondary_skill_ids].compact
      end

      reactions << c.data['reaction'] if c.data['reaction'].present?
    }

    other_skills = Skill.where(id: generic_skills.map(&:to_i))
    other_reactions = Skill.where(id: reactions.map(&:to_i))

    base_scope = where.not(id: generic_skills.map(&:to_i))
    base_scope = base_scope.where.not("skills.data ->> 'memgen_id' IN (?)", other_reactions.map{|r| r.data['memgen_id']}) if other_reactions.present?

    return base_scope if char.monster?

    base_scope.where.not(name: other_skills.where(name: ['Fly']).select(:name))
  }

  def formula
    data['formula']
  end

  def requires_sword?
    data['formula'].match?(/requires sword/i)
  end

  def data=(value)
    self[:data] = value.is_a?(String) ? JSON.parse(value) : value
  end
end
