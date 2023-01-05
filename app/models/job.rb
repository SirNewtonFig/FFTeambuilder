class Job < ApplicationRecord
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

  has_many :skills
  has_many :innates
  has_many :innate_skills, through: :innates, source: :skill
  has_many :prerequisites
  has_many :prerequisite_jobs, through: :prerequisites, source: :prerequisite, class_name: 'Job'

  scope :valid, ->(char) { where("(jobs.data -> '#{char.sex}') is not null") }
  
  scope :secondary, ->(char) {
    s = where.not(name: 'Mime')
          .where.not(id: char.data['job'])

    s = s.where('1=0') if char.data['job'].to_i == 20

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
end
