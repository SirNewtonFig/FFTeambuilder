require 'csv'

Job.upsert_all(YAML.safe_load_file(Rails.root.join('db/seeds/jobs.yml')))

Prerequisite.upsert_all(YAML.safe_load_file(Rails.root.join('db/seeds/prerequisites.yml')))

Dir.glob('db/seeds/skills/*.yml').each do |f|
  Skill.upsert_all(YAML.safe_load_file(f))
end

Innate.upsert_all(YAML.safe_load_file(Rails.root.join('db/seeds/innates.yml')))

Dir.glob('db/seeds/items/*.csv').each do |f|
  items = CSV.parse(File.read(f), headers: true)

  items.each do |row|
    item = Item.create(
      name: row['Name'],
      item_type: File.basename(f, '.csv').singularize,
      data: {
        wp: row['WP'],
        w_ev: row['W-EV'],
        ev_p: row['Phys Evade'],
        ev_m: row['Magic Evade'],
        flags: row['Flags'],
        hp: row['HP'],
        mp: row['MP'],
        speed: row['Extras']&.match(/\+(\d+) speed/i)&.captures&.first,
        magic: row['Extras']&.match(/\+(\d+) MA/i)&.captures&.first,
        attack: row['Extras']&.match(/\+(\d+) PA/i)&.captures&.first,
        jump: row['Extras']&.match(/\+(\d+) jump/i)&.captures&.first,
        move: row['Extras']&.match(/\+(\d+) move/i)&.captures&.first,
        add: row['Add'],
        cancels: row['Cancels'],
        element: row['Element'],
        proc: row['Proc'],
        strengthens: row['Strengthens'],
        always: row['Always'],
        formula: row['Formula'],
        absorbs: row['Absorbs'],
        halves: row['Halves'],
        weakness: row['Weakness'],
        female_only: row['Classes'] == 'Female'
      }
    )

    equippable_jobs = Job.where(abbreviation: row['Classes'].split(' ')) if row['Classes'].present? && row['Classes'] !~ /NOT/
    equippable_jobs = Job.where.not(abbreviation: row['Classes'].split(' ')[1..-1]) if row['Classes'].present? && row['Classes'] =~ /NOT/
    equippable_jobs = Job.all if row['Classes'].blank?

    equippable_jobs.where.not(id: 20).each do |job|
      Proficiency.create(item: item, record: job)
    end

    skill = Skill.find_by(name: row['Skill'])
    Proficiency.create(item: item, record: skill) if skill.present?
  end
end

monsters = CSV.parse(File.read(Rails.root.join('db/seeds/monsters.csv')), headers: true)

monsters.each do |row|
  monster = Job.create(
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
        abilities: [
          row['Ability 1'],
          row['Ability 2'],
          row['Ability 3']
        ],
        monster_skill: row['Monster Skill'],
        notes: [
          (row['Note 1'] unless row['Note 1'] == 'None' || row['Note 1'].blank?),
          (row['Note 2'] unless row['Note 2'] == 'None' || row['Note 2'].blank?),
          (row['Note 3'] unless row['Note 3'] == 'None' || row['Note 3'].blank?),
          (row['Note 4'] unless row['Note 4'] == 'None' || row['Note 4'].blank?)
        ].compact
      }
    }
  )
end
