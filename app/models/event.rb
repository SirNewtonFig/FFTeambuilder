class Event < ApplicationRecord
  extend Memoist

  STATES = ['open', 'published', 'started', 'closed']

  has_many :submissions, dependent: :destroy
  has_many :teams, through: :submissions
  belongs_to :user

  before_destroy :delete_challonge

  scope :active, -> { where(active: true) }
  scope :open, -> { where(deadline: Time.current..) }

  def mine?
    user == Current.user
  end

  def open?
    deadline.future?
  end

  def show_bracket?
    external_id.present? && (['started', 'closed'].include?(state) || mine?)
  end

  def show_standings?
    state == 'closed' && submissions.any? { |s| s.rank.present? }
  end

  def show_memgen?
    ['started', 'closed'].include?(state)
  end

  def delete_challonge
    Event::Destroy.perform(event: self)

    external_id = nil
  end
end
