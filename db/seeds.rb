require 'csv'

jobs = CSV.parse(File.read(Rails.root.join('db/seeds/jobs.csv')), headers: true)
Data::Import::ImportJobs.perform(jobs:)

Prerequisite.destroy_all
prerequisites = CSV.parse(File.read(Rails.root.join('db/seeds/prerequisites.csv')), headers: true)
Data::Import::ImportPrerequisites.perform(prerequisites:)

skills = CSV.parse(File.read(Rails.root.join('db/seeds/skills.csv')), headers: true)
Data::Import::ImportSkills.perform(skills:)

items = {}
Dir.glob('db/seeds/items/*.csv').each do |f|
  items[File.basename(f, '.csv').singularize] = CSV.parse(File.read(f), headers: true)
end
Data::Import::ImportItems.perform(items:)

monsters = CSV.parse(File.read(Rails.root.join('db/seeds/monsters.csv')), headers: true)
Data::Import::ImportMonsters.perform(monsters:)

mskills = CSV.parse(File.read(Rails.root.join('db/seeds/monster_skills.csv')), headers: true)
Data::Import::ImportMonsterSkills.perform(mskills:)

passives = CSV.parse(File.read(Rails.root.join('db/seeds/monster_passives.csv')), headers: true)
Data::Import::ImportMonsterPassives.perform(passives:)

statuses = CSV.parse(File.read(Rails.root.join('db/seeds/statuses.csv')), headers: true)
Data::Import::ImportStatuses.perform(statuses:)

Exclusion.find_or_create_by(
  ability_a: MonsterPassive.find_by(job: Job.find_by(name: 'Bomb'), name: 'AllDef+ Weak:Water'),
  ability_b: Skill.find_by(job: Job.find_by(name: 'Bomb'), name: 'Defense UP')
)

Data::Import::ImportInnates.perform