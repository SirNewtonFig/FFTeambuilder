class Team < ApplicationRecord
  extend Memoist

  has_many :submissions, inverse_of: :team, dependent: :destroy
  has_many :events, through: :submissions

  enum :palette_a, %i{ blue red green white purple yellow brown black }, suffix: true, _scopes: false
  enum :palette_b, %i{ blue red green white purple yellow brown black }, suffix: true, _scopes: false

  validates :user_id, presence: true

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
end
