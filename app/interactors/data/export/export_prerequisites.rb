require 'csv'

class Data::Export::ExportPrerequisites < ActiveInteractor::Base
  delegate :io, to: :context

  def perform
    context.io = StringIO.new

    headers = [
      'Job',
      'Prereqs'
    ]

    io << CSV.generate_line(headers, encoding: 'utf-8')

    Job.generic.order(:id).each do |job|
      next if job.prerequisites.blank?

      requirements = []

      job.prerequisites.order(:job_id).each do |prereq|
        requirements << "#{prereq.level} #{prereq.prerequisite.name}"
      end

      row = [job.name, requirements.join(',')]

      io << CSV.generate_line(row, encoding: 'utf-8')
    end

    io.rewind
  end
end
