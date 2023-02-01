class Team < ApplicationRecord
  extend Memoist

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
    characters.map(&:brave).sum
  end

  def faith_total
    characters.map(&:faith).sum
  end

  def jp_total
    characters.map(&:jp_total).sum
  end
end
