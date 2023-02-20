class Character::CalculateUnlockJpContext < ActiveInteractor::Context::Base
  attributes :character, :spread

  validates :character, presence: true
end

class Character::CalculateUnlockJp < ActiveInteractor::Base
  delegate :character, to: :context

  def perform
    all_costs = Job.generic.map do |job|
      unlock_costs = Job::CalculatePrerequisiteJp.perform(job: job).jp
      
      character.jp_spread.each do |j, cost|
        next if unlock_costs[j].blank?

        unlock_costs[j] = [unlock_costs[j] - cost, 0].max
      end

      [job, unlock_costs.values.sum]
    end

    context.spread = all_costs.to_h
  end
end
