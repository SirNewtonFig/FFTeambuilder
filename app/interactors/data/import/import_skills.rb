class Data::Import::ImportSkills < ActiveInteractor::Base
  delegate :skills, :skillmap, to: :context
  
  before_perform :setup_skillmap
  after_perform :cleanup!
  
  def perform
    skills.each do |row|
      next if row['Skill ID'].blank?

      job = Job.find_by(name: row['Class'].strip)
      
      skill_type = 'action'
      skill_type = 'reaction' if row['Skill Name'].match?(/^R:/)
      skill_type = 'support' if row['Skill Name'].match?(/^E:/)
      skill_type = 'movement' if row['Skill Name'].match?(/^S:/)

      skill = Skill.find_by("job_id = ? AND data ->> 'memgen_id' = ?", job.id, row['Skill ID'].rjust(4, '0')) || Skill.new

      skillmap[job] ||= []
      skillmap[job] << row['Skill ID'].rjust(4, '0')

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
          xa: row['XA:'],
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
  end

  private

    def setup_skillmap
      context.skillmap = {}
    end

    def cleanup!
      skillmap.each do |job, skill_ids|
        job.skills.where.not("data ->> 'memgen_id' IN (:ids)", ids: skill_ids).destroy_all
      end
    end
end
