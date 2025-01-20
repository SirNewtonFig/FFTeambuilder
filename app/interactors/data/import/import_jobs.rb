class Data::Import::ImportJobs < ActiveInteractor::Base
  delegate :jobs, to: :context

  def perform
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
  end
end
