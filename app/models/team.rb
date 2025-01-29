class Team < ApplicationRecord
  extend Memoist

  has_many :submissions, inverse_of: :team, dependent: :destroy
  has_many :events, through: :submissions

  belongs_to :user, optional: true

  enum :palette_a, %i{ blue red green white purple yellow brown black }, suffix: true, _scopes: false
  enum :palette_b, %i{ blue red green white purple yellow brown black }, suffix: true, _scopes: false

  validates :user_id, presence: true

  scope :for_event, ->(event) {
    joins(:events)
      .where(events: {id: event.id })
      .order('submissions.team_name_override, teams.player_name, submissions.priority')
      .select('teams.*, submissions.team_name_override, submissions.player_name_override')
  }

  def self.blank_team_attributes
    {
      palette_a: 'blue',
      palette_b: 'red',
      data: [
        Character.blank_character.data,
        Character.blank_character.data,
        Character.blank_character.data,
        Character.blank_character.data
      ]
    }
  end

  memoize def characters
    data.map { |d| Character.new(d) }
  end

  def brave_total
    characters.map(&:brave).map(&:to_i).sum
  end

  def faith_total
    characters.map(&:faith).map(&:to_i).sum
  end

  def jp_total
    characters.map(&:jp_total).sum
  end

  def guest?
    user.blank?
  end

  def mine?
    user_id == Current.user.id
  end

  # TODO: move this into a serializer
  def data
    super.map! { |char| intcast_values(char) }
  end

  private

    def intcast_values(enum)
      if enum.respond_to?(:keys)
        enum.each do |k, v|
          if k.match?(/name/)
            enum[k] = v
          else
            enum[k] = intcast_values(v)
          end
        end
      elsif enum.is_a?(Enumerable)
        enum.map! do |v|
          v.to_i == 0 ? v : v.to_i
        end
      else
        enum.to_i == 0 ? enum : enum.to_i
      end
    rescue => e
      puts enum.inspect
      raise e
    end
end
