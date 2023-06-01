# Job.upsert_all(YAML.safe_load_file(Rails.root.join('db/seeds/yml/jobs.yml')))
# Skill.upsert_all(YAML.safe_load_file(Rails.root.join('db/seeds/yml/skills.yml')))
# Item.upsert_all(YAML.safe_load_file(Rails.root.join('db/seeds/yml/items.yml')))
# Innate.upsert_all(YAML.safe_load_file(Rails.root.join('db/seeds/yml/innates.yml')))
# Prerequisite.upsert_all(YAML.safe_load_file(Rails.root.join('db/seeds/yml/prerequisites.yml')))
# Proficiency.upsert_all(YAML.safe_load_file(Rails.root.join('db/seeds/yml/proficiencies.yml')))

require 'csv'

jobs = CSV.parse(File.read(Rails.root.join('db/seeds/jobs.csv')), headers: true)
jobs.each do |row|
  job = Job.find_or_initialize_by(name: row['Class'].strip)
  job.data ||= {}

  sex = row['Sex'].downcase

  job.update(
    abbreviation: row['Abbreviation'],
    skillset: row['Secondary Name'],
    data: job.data.merge({

      sex => {
        hp: row['HP'],
        mp: row['MP'],
        speed: row['Speed'],
        move: row['Move'],
        jump: row['Jump'],
        attack: row['PA'],
        magic: row['MA'],
        evade: row['Evade'],
        hp_mult: row['HPmult'],
        mp_mult: row['MPmult'],
        sp_mult: row['SPmult'],
        pa_mult: row['PAmult'],
        ma_mult: row['MAmult'],
        memgen_id: row['Job ID'],
        secondary_id: row['Secondary ID']
      }
    })
  )
end

Prerequisite.destroy_all
Prerequisite.upsert_all(YAML.safe_load_file(Rails.root.join('db/seeds/prerequisites.yml')))

sage = Job.find_by(name: 'Sage')

sage.prerequisites.create!(prerequisite: Job.find_by(name: 'Wizard'), level: 5)
sage.prerequisites.create!(prerequisite: Job.find_by(name: 'Priest'), level: 5)
sage.prerequisites.create!(prerequisite: Job.find_by(name: 'Time Mage'), level: 4)
sage.prerequisites.create!(prerequisite: Job.find_by(name: 'Oracle'), level: 4)

engineer = Job.find_by(name: 'Engineer')

engineer.prerequisites.create!(prerequisite: Job.find_by(name: 'Archer'), level: 3)
engineer.prerequisites.create!(prerequisite: Job.find_by(name: 'Chemist'), level: 3)

skills = CSV.parse(File.read(Rails.root.join('db/seeds/skills.csv')), headers: true)
skills.each do |row|
  job = Job.find_by(name: row['Class'].strip)
  
  skill_type = 'action'
  skill_type = 'reaction' if row['Skill Name'].match?(/^R:/)
  skill_type = 'support' if row['Skill Name'].match?(/^S:/)
  skill_type = 'movement' if row['Skill Name'].match?(/^M:/)

  lookup_attrs = { skill_type: skill_type, name: row['Skill Name'].gsub(/^R:|^S:|^M:/, '').strip }
  lookup_attrs[:job_id] = job.id if skill_type == 'movement'

  skill = Skill.find_or_initialize_by(lookup_attrs)

  skill.update(
    job: job,
    jp_cost: row['JP Cost'],
    skill_type: skill_type,
    data: {
      range: row['Range'],
      area: row['AoE'],
      target: row['Target'],
      vert: row['Vertical Tolerance'],
      ct: row['CT'],
      mp: row['MP'],
      element: row['Element'],
      evade: row['Evade Type'],
      reflectable: row['Reflectable?'],
      silence: row['Silence?'],
      formula: row['Formula'],
      counter: row['Counter?'],
      counter_magic: row['Counter Magic?'],
      counter_flood: row['Counter Flood?'],
      move: row['Move'],
      jump: row['Jump'],
      memgen_id: row['Skill ID'].rjust(4, '0'),
      mimic: ('Yes' unless row['Mimic?'] == 'No')
    }
  )

  skill.save
end

Innate.destroy_all
Innate.upsert_all(YAML.safe_load_file(Rails.root.join('db/seeds/innates.yml')))

Dir.glob('db/seeds/items/*.csv').each do |f|
  items = CSV.parse(File.read(f), headers: true)
  items.each do |row|
    item = Item.find_or_initialize_by(name: row['Name'])

    item.update(
      item_type: File.basename(f, '.csv').singularize,
      data: {
        wp: row['WP'],
        w_ev: row['W-EV'],
        ev_p: row['Phys Evade'],
        ev_m: row['Magic Evade'],
        flags: row['Flags'],
        hp: row['HP'],
        mp: row['MP'],
        speed: row['Speed'],
        magic: row['MA'],
        attack: row['PA'],
        jump: row['Jump'],
        move: row['Move'],
        add: row['Adds:'],
        cancels: row['Cancels:'],
        element: row['Element:'],
        proc: row['Proc:'],
        strengthens: row['Strengthens:'],
        always: row['Always:'],
        start: row['Start:'],
        formula: row['Formula:'],
        proc_formula: row['Proc Formula:'],
        absorbs: row['Absorbs:'],
        halves: row['Halves:'],
        weakness: row['Weak:'],
        female_only: row['Classes'] == 'Female',
        memgen_id: row['Item ID'].rjust(2, '0')
      }
    )

    equippable_jobs = Job.none
    equippable_jobs = Job.generic.where(abbreviation: row['Classes'].split(' ')) if row['Classes'].present? && row['Classes'] !~ /NOT|ALL/
    equippable_jobs = Job.generic.where.not(name: 'Mime').where.not(abbreviation: row['Classes'].split(' ')[1..-1]) if row['Classes'].present? && row['Classes'] =~ /NOT/
    equippable_jobs = Job.generic.where.not(name: 'Mime') if row['Classes'] =~ /ALL/

    item.job_ids = equippable_jobs.pluck(:id)
    item.skill_ids = Skill.where(name: row['Skill']).pluck(:id)
  end
end

mskills = CSV.parse(File.read(Rails.root.join('db/seeds/monster_skills.csv')), headers: true)
mskills.each do |row|
  skill = MonsterSkill.find_or_initialize_by(name: row['Ability'])

  skill.update(
    data: {
      range: row['Range'],
      area: row['AoE'],
      target: row['Target'],
      vert: row['Vertical Tolerance'],
      ct: row['CT'],
      element: row['Element'],
      evade: row['Evade Type'],
      reflectable: row['Reflectable?'],
      formula: row['Formula'],
      counter: row['Counter?'],
      counter_magic: row['Counter Magic?'],
      counter_flood: row['Counter Flood?'],
      mimic: row['Mimic?']
    }
  )

  skill.save
end

monsters = CSV.parse(File.read(Rails.root.join('db/seeds/monsters.csv')), headers: true)
monsters.each do |row|
  monster = Job.find_or_initialize_by(name: row['Name'])

  monster.update(
    data: {
      'x' => {
        hp: row['HP'],
        mp: row['MP'],
        speed: row['Speed'],
        move: row['Move'],
        jump: row['Jump'],
        attack: row['PA'],
        magic: row['MA'],
        abilities: [
          row['Ability 1'],
          row['Ability 2'],
          row['Ability 3']
        ],
        monster_skill: row['Monster Skill'],
        notes: [
          row['Reaction'],
          row['Support'],
          row['Movement'],
          row['Water'],
          row['Family Notes:']
        ].reject{|x| x.blank? || x == 'None' },
        evade: row['Evade'],
        hp_mult: row['HPmult'],
        mp_mult: row['MPmult'],
        sp_mult: row['SPmult'],
        pa_mult: row['PAmult'],
        ma_mult: row['MAmult'],
        memgen_id: row['Job ID'],
        jp_cost: row['JP Cost']
      }
    }
  )
end

Job.all.each do |job|
  data = job.data

  if job.generic? && job.name != 'Engineer'
    data.deep_merge!({'m' => { 'character_set' => '80' }}) if data.key?('m')
    data.deep_merge!({'f' => { 'character_set' => '81' }}) if data.key?('f')
  elsif job.generic?
    data.deep_merge!({
      'm' => { 'character_set' => '16' },
      'f' => { 'character_set' => '21' }
    })
  else
    data.deep_merge!({
      'x' => { 'character_set' => '82' }
    })
  end

  job.update(data: data)
end
