class Data::Import::ImportMonsterSkills < ActiveInteractor::Base
  delegate :mskills, to: :context

  def perform
    mskills.each do |row|
      next if row['Skill ID'].blank?

      job = Job.find_by(name: row['Class'].strip)

      skill = Skill.find_by("job_id = ? AND data ->> 'memgen_id' = ?", job.id, row['Skill ID'].rjust(4, '0')) || Skill.new

      skill_type = 'action'
      skill_type = 'reaction' if row['Skill Name'].match?(/^R:/)
      skill_type = 'support' if row['Skill Name'].match?(/^E:/)
      skill_type = 'movement' if row['Skill Name'].match?(/^S:/)

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
          element: row['Element'],
          evade: row['Evade Type'],
          reflectable: row['Reflectable?'],
          xa: row['XA:'],
          formula: row['Formula'],
          proc: row['Proc'],
          proc_rate: row['Proc Rate'],
          counter: row['Counter?'],
          counter_magic: row['Counter Magic?'],
          counter_flood: row['Counter Flood?'],
          memgen_id: row['Skill ID'].rjust(4, '0'),
          mimic: ('Yes' if row['Mimic?'] == 'Yes'),
          atk_up: row['Atk Up?'],
          matk_up: row['MAtk Up?'],
          martial_arts: row['Martial Arts?'],
          protect: row['Protect?'],
          shell: row['Shell?']
        }
      )
    end
  end
end
