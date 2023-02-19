class Skill < ApplicationRecord
  enum :skill_type, %i{ action reaction support movement }
  # serialize :data, HashWithIndifferentAccess

  belongs_to :job, optional: true

  scope :valid, ->(char) {
    s = joins(:job).merge(Job.valid(char))
    s = s.where('1=0') unless char.can_equip_skills?

    s
  }

  scope :unique, ->(char, team) {
    other_skills = (team.characters - [char]).map { |c|
      [c.data['reaction'], c.data['support'], c.data['movement'], *c.primary_skill_ids, *c.secondary_skill_ids]
    }.compact.flatten.map(&:to_i)

    where.not(id: other_skills)
  }
end
