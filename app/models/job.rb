class Job < ApplicationRecord
  extend Memoist

  JP_REQUIREMENTS = [
      0,
      0,  # level 1
    200,  # level 2
    350,  # level 3
    550,  # level 4
    800,  # level 5
    1150, # level 6 (unused)
    1550, # level 7 (unused)
    2100  # level 8 (unused)
  ].freeze

  # serialize :data, HashWithIndifferentAccess

  has_many :skills, dependent: :destroy
  has_many :innates, dependent: :destroy
  has_many :innate_skills, through: :innates, source: :skill
  has_many :prerequisites, dependent: :destroy
  has_many :prerequisite_jobs, through: :prerequisites, source: :prerequisite, class_name: 'Job'
  has_many :proficiencies, as: :record, dependent: :destroy

  has_many :monster_passives, class_name: 'MonsterPassive'

  scope :valid, ->(char) { where("(jobs.data -> '#{char.sex}') is not null") }
  
  scope :secondary, ->(char) {
    s = where.not(name: 'Mime')
          .where.not(id: char.data['job'])

    s = s.none if char.job.name == 'Mime'

    s
  }

  scope :generic, -> { where("(jobs.data -> 'x') is null") }
  scope :monster, -> { where("(jobs.data -> 'x') is not null") }

  def generic?
    !data.key?('x')
  end

  def monster?
    data.key?('x')
  end

  memoize def prerequisite_jp
    raw_cost = data[data.keys.first]['jp_cost']

    return raw_cost.to_i unless raw_cost.blank?

    Job::CalculatePrerequisiteJp.perform(job: self)
      .jp
      .values
      .sum
  end
end
