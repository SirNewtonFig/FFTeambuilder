class Job::CalculatePrerequisiteJpContext < ActiveInteractor::Context::Base
  attributes :job, :jp

  validates :job, presence: true
end

class Job::CalculatePrerequisiteJp < ActiveInteractor::Base
  delegate :job, to: :context

  def perform
    context.jp = splat_prereqs(job)
      .map { |job, levels| [job, Job::JP_REQUIREMENTS[levels]] }
      .to_h
  end

  private

    def splat_prereqs(j)
      jobs = {}

      j.prerequisites.each do |p|
        jobs[p.prerequisite] = p.level unless jobs[p.prerequisite].to_i > p.level

        splat_prereqs(p.prerequisite).each do |key, value|
          jobs[key] = value unless jobs[key].to_i > value
        end
      end

      jobs
    end
end
