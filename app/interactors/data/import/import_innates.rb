class Data::Import::ImportInnates < ActiveInteractor::Base
  def perform
    Job.find_by(name: 'Samurai').innates.find_or_create_by(skill: Skill.find_by(name: 'Two Hands'))
    Job.find_by(name: 'Monk').innates.find_or_create_by(skill: Skill.find_by(name: 'Martial Arts'))
    Job.find_by(name: 'Spellblade').innates.find_or_create_by(skill: Skill.find_by(name: 'Maintenance'))
    Job.find_by(name: 'Paladin').innates.find_or_create_by(skill: Skill.find_by(name: 'Piety'))
    Job.find_by(name: 'Ninja').innates.find_or_create_by(skill: Skill.find_by(name: 'Abandon'))
    Job.find_by(name: 'Chemist').innates.find_or_create_by(skill: Skill.find_by(name: 'Throw Item'))
    Job.find_by(name: 'Geomancer').innates.find_or_create_by(skill: Skill.find_by(name: 'Any Ground'))
    Job.find_by(name: 'Mediator').innates.find_or_create_by(skill: Skill.find_by(name: 'Monster Talk'))
    Job.find_by(name: 'Blood Mage').innates.find_or_create_by(skill: Skill.find_by(name: 'Ritual'))
  end
end


