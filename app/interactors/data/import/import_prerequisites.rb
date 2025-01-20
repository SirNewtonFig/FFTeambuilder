class Data::Import::ImportPrerequisites < ActiveInteractor::Base
  delegate :prerequisites, to: :context

  before_perform :truncate_prereqs
  
  def perform
    prerequisites.each do |row|
      job = Job.find_by(name: row['Job'])
      row['Prereqs'].split(',').each do |prereq|
        level, name = prereq.match(/(\d) ([\w\s]+)/)[1..2]
    
        record = Prerequisite.create!(job: job, prerequisite_id: Job.find_by(name: name).id, level: level)
      end
    end
  end

  private

    def truncate_prereqs
      Prerequisite.destroy_all
    end
end
