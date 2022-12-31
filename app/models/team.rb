class Team < ApplicationRecord
  extend Memoist

  DEFAULT_DATA = ([Character::DEFAULT_DATA] * 4 )

  enum :palette_a, %i{ blue red green white purple yellow brown black }
  # enum :palette_b, %i{ blue red green white purple yellow brown black }

  validates :user_id, presence: true

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
