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
        m_evade: row['MEvade'],
        hp_mult: row['HPmult'],
        mp_mult: row['MPmult'],
        sp_mult: row['SPmult'],
        pa_mult: row['PAmult'],
        ma_mult: row['MAmult'],
        memgen_id: row['Job ID'],
        secondary_id: row['Secondary ID'],
        character_set: row['Charset'],
        jp_cost: row['JP Cost'],
        innate: row['Innate']
      }
    })
  )
end

Prerequisite.destroy_all
prerequisites = CSV.parse(File.read(Rails.root.join('db/seeds/prerequisites.csv')), headers: true)
prerequisites.each do |row|
  job = Job.find_by(name: row['Job'])
  row['Prereqs'].split(',').each do |prereq|
    level, name = prereq.match(/(\d) ([\w\s]+)/)[1..2]

    record = Prerequisite.create!(job: job, prerequisite_id: Job.find_by(name: name).id, level: level)
  end
end

skills = CSV.parse(File.read(Rails.root.join('db/seeds/skills.csv')), headers: true)
skills.each do |row|
  next if row['Skill ID'].blank?

  job = Job.find_by(name: row['Class'].strip)
  
  skill_type = 'action'
  skill_type = 'reaction' if row['Skill Name'].match?(/^R:/)
  skill_type = 'support' if row['Skill Name'].match?(/^E:/)
  skill_type = 'movement' if row['Skill Name'].match?(/^S:/)

  skill = Skill.find_by("job_id = ? AND data ->> 'memgen_id' = ?", job.id, row['Skill ID'].rjust(4, '0')) || Skill.new

  skill.update(
    name: row['Skill Name'].gsub(/^R:|^E:|^S:/, '').strip,
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
      formula: row['Formula'],
      counter: row['Counter?'],
      counter_magic: row['Counter Magic?'],
      counter_flood: row['Counter Flood?'],
      move: row['Move'],
      jump: row['Jump'],
      memgen_id: row['Skill ID'].rjust(4, '0'),
      mimic: ('Yes' unless row['Mimic?'] == 'No'),
      atk_up: row['Atk Up?'],
      matk_up: row['MAtk Up?'],
      martial_arts: row['Martial Arts?'],
      two_hands: row['Two Hands?'],
      two_swords: row['Two Swords?'],
      protect: row['Protect?'],
      shell: row['Shell?']
    }
  )
end

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
        immune: row['Immune:'],
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
        memgen_id: row['Item ID'].rjust(2, '0'),
        extra_items: row['Extra Items'],
        extra_effects: row['Extra Effects:']
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

monsters = CSV.parse(File.read(Rails.root.join('db/seeds/monsters.csv')), headers: true)
monsters.each do |row|
  next if row['Job ID'].blank?
  
  monster = Job.monster.find_by("data -> 'x' ->> 'memgen_id' = ?", row['Job ID']) || Job.new

  monster.update(
    name: row['Name'],
    data: {
      'x' => {
        hp: row['HP'],
        mp: row['MP'],
        speed: row['Speed'],
        move: row['Move'],
        jump: row['Jump'],
        attack: row['PA'],
        magic: row['MA'],
        notes: [
          row['Reaction'],
          row['Support'],
          row['Movement'],
          row['Water'],
          row['Family Notes:']
        ].reject{|x| x.blank? || x == 'None' },
        evade: row['Evade'],
        m_evade: row['MEvade'],
        hp_mult: row['HPmult'],
        mp_mult: row['MPmult'],
        sp_mult: row['SPmult'],
        pa_mult: row['PAmult'],
        ma_mult: row['MAmult'],
        memgen_id: row['Job ID'],
        jp_cost: row['JP Cost'],
        character_set: '82'
      }
    }
  )
end

mskills = CSV.parse(File.read(Rails.root.join('db/seeds/monster_skills.csv')), headers: true)
mskills.each do |row|
  next if row['Skill ID'].blank?

  job = Job.find_by(name: row['Monster'].strip)

  skill = Skill.find_by("job_id = ? AND data ->> 'memgen_id' = ?", job.id, row['Skill ID'].rjust(4, '0')) || Skill.new

  skill_type = 'action'
  skill_type = 'reaction' if row['Ability'].match?(/^R:/)
  skill_type = 'support' if row['Ability'].match?(/^E:/)
  skill_type = 'movement' if row['Ability'].match?(/^S:/)

  skill.update(
    name: row['Ability'].gsub(/^R:|^E:|^S:/, '').strip,
    job: job,
    jp_cost: row['JP Cost'],
    skill_type: skill_type,
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
      memgen_id: row['Skill ID'].rjust(4, '0'),
      mimic: ('Yes' unless row['Mimic?'] == 'No'),
      atk_up: row['Atk Up?'],
      matk_up: row['MAtk Up?'],
      martial_arts: row['Martial Arts?'],
      protect: row['Protect?'],
      shell: row['Shell?']
    }
  )
end

passives = CSV.parse(File.read(Rails.root.join('db/seeds/monster_passives.csv')), headers: true)
passives.each do |row|
  job = Job.find_by(name: row['Monster'].strip)

  passive = MonsterPassive.find_by("job_id = ? AND data ->> 'index' = ?", job.id, row['Index']) || MonsterPassive.new

  passive.update(
    name: row['Name'].strip,
    job: job,
    jp_cost: row['JP Cost'],
    data: {
      ev_p: row['Phys Evade'],
      ev_m: row['Magic Evade'],
      hp: row['HP'],
      mp: row['MP'],
      speed: row['Speed'],
      magic: row['MA'],
      attack: row['PA'],
      jump: row['Jump'],
      move: row['Move'],
      immune: row['Immune:'],
      strengthens: row['Strengthens:'],
      always: row['Always:'],
      start: row['Start:'],
      absorbs: row['Absorbs:'],
      halves: row['Halves:'],
      weakness: row['Weak:'],
      memgen_id: row['Skill ID']&.rjust(4, '0'),
      index: row['Index']
    }
  )
end

Job.find_by(name: 'Samurai').innates.find_or_create_by(skill: Skill.find_by(name: 'Two Hands'))

statuses = CSV.parse(File.read(Rails.root.join('db/seeds/statuses.csv')), headers: true)

statuses.each do |row|
  status = Status.find_or_initialize_by(name: row['Status'])

  status.update(
    default_priority: row['Default Priority'].to_i,    # could be N/A, coerce it to 0
    description: row['Description'],
    duration: row['Duration'],
    indicator: row['Indicator'],
    show_priority: row['Default Priority'] != 'N/A'
  )
end

Exclusion.create!(
  ability_a: MonsterPassive.find_by(job: Job.find_by(name: 'Bomb'), name: 'AllDef+ Weak:Ice'),
  ability_b: Skill.find_by(job: Job.find_by(name: 'Bomb'), name: 'Defense UP')
)
