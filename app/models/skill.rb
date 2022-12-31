class Skill < ApplicationRecord
  enum :skill_type, %i{ action reaction support movement }
  # serialize :data, HashWithIndifferentAccess

  belongs_to :job

  scope :valid, ->(char) {
    s = joins(:job).merge(Job.valid(char))
    s = s.where('1=0') if char.data['job'].to_i == 20

    s
  }
end
