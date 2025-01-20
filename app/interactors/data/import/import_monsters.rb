class Data::Import::ImportMonsters < ActiveInteractor::Base
  delegate :monsters, to: :context

  def perform
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
  end
end
