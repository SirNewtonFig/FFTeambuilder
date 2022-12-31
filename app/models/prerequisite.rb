class Prerequisite < ApplicationRecord
  belongs_to :job
  belongs_to :prerequisite, class_name: 'Job'
end
