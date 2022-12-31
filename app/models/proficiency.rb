class Proficiency < ApplicationRecord
  belongs_to :item
  belongs_to :record, polymorphic: true
end
