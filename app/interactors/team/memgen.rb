class Team::MemgenContext < ActiveInteractor::Context::Base
  attributes :team, :palette, :player
  attribute :block, default: -> { [] }

  validates :team, :palette, :player, presence: true
end

class Team::Memgen < ActiveInteractor::Base
  delegate :team, :palette, :player, :block, to: :context

  def perform
    team.characters.each_with_index do |char, i|
      block << Character::Memgen.perform(character: char, slot: i + player, palette: palette).block.join
    end
  end
end
