class Job::CalculateSkillJpContext < ActiveInteractor::Context::Base
  attributes :character, :jp

  validates :character, presence: true
end

class Job::CalculateSkillJp < ActiveInteractor::Base
  delegate :character, to: :context

  def perform
    context.jp = skills.group_by(&:job)
      .map {|job, skills| [job, skills.map(&:jp_cost).sum] }
      .to_h
  end

  private

    def skills
      [
        character.reaction,
        character.support,
        character.movement,
        *character.primary_skills,
        *character.secondary_skills
      ].compact
    end
end
