class Data::Import::ImportMonsterPassives < ActiveInteractor::Base
  delegate :passives, to: :context
  
  def perform
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
  end
end
