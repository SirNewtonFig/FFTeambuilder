class Event < ApplicationRecord
  has_many :submissions, dependent: :destroy
  has_many :teams, through: :submissions
  belongs_to :user
  
  scope :active, -> { where(active: true) }
  scope :open, -> { where(deadline: Time.current..) }

  def mine?
    user == Current.user
  end
end
