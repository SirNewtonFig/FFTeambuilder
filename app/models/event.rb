class Event < ApplicationRecord
  extend Memoist

  has_many :submissions, dependent: :destroy
  has_many :teams, through: :submissions
  belongs_to :user
  
  scope :active, -> { where.not(state: 'closed') }
  scope :open, -> { where(deadline: Time.current..) }

  def mine?
    user == Current.user
  end

  def open?
    deadline.future?
  end

  def show_bracket?
    external_id.present? && (state == 'started' || mine?)
  end
end
