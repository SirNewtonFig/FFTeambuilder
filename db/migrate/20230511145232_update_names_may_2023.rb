class UpdateNamesMay2023 < ActiveRecord::Migration[7.0]
  def change
    Job.find_by(name: 'Marksman').update(name: 'Archer')
    Job.find_by(name: 'Spellblade')&.destroy
    Skill.find_by(name: 'Power Source').update(name: 'Ambrosia')
    Skill.find_by(name: 'Backstab').update(name: 'Vital Strike')
    Skill.joins(:job).find_by(skills: { name: 'Blizzard' }, jobs: { name: 'Geomancer' }).update(name: 'Snowstorm')
  end
end
