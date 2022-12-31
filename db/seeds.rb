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
  end
end
