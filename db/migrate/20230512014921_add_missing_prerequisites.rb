class AddMissingPrerequisites < ActiveRecord::Migration[7.0]
  def change
    sage = Job.find_by(name: 'Sage')

    sage.prerequisites.create!(prerequisite: Job.find_by(name: 'Wizard'), level: 5)
    sage.prerequisites.create!(prerequisite: Job.find_by(name: 'Priest'), level: 5)
    sage.prerequisites.create!(prerequisite: Job.find_by(name: 'Time Mage'), level: 4)
    sage.prerequisites.create!(prerequisite: Job.find_by(name: 'Oracle'), level: 4)

    engineer = Job.find_by(name: 'Engineer')

    engineer.prerequisites.create!(prerequisite: Job.find_by(name: 'Archer'), level: 3)
    engineer.prerequisites.create!(prerequisite: Job.find_by(name: 'Chemist'), level: 3)
  end
end
