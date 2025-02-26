require 'csv'

class Data::Export::ExportMonsterSkills < ActiveInteractor::Base
  delegate :io, to: :context

  def perform
    context.io = StringIO.new

    headers = [
      'Class',
      'Skill Name',
      'Skill ID',
      'JP Cost',
      'Range',
      'AoE',
      'Target',
      'Vertical Tolerance',
      'CT',
      'MP',
      'Element',
      'Evade Type',
      'Reflectable?',
      'XA:',
      'Formula',
      'Counter?',
      'Counter Magic?',
      'Counter Flood?',
      'Mimic?',
      'Move',
      'Jump',
      'Atk Up?',
      'MAtk Up?',
      'Martial Arts?',
      'Two Hands?',
      'Two Swords?',
      'Protect?',
      'Shell?',
    ]

    io << CSV.generate_line(headers, encoding: 'utf-8')

    Skill.joins(:job).merge(Job.monster).order(Arel.sql "jobs.id, skills.skill_type, skills.data ->> 'memgen_id' desc").includes(:job).each do |skill|
      row = [
        skill.job.name,
        skill_name(skill),
        skill.data['memgen_id'],
        skill.jp_cost,
        skill.data['range'],
        skill.data['area'],
        skill.data['target'],
        skill.data['vert'],
        skill.data['ct'],
        skill.data['mp'],
        skill.data['element'],
        skill.data['evade'],
        skill.data['reflectable'],
        skill.data['xa'],
        skill.data['formula'],
        skill.data['counter'],
        skill.data['counter_magic'],
        skill.data['counter_flood'],
        skill.data['mimic'],
        skill.data['move'],
        skill.data['jump'],
        skill.data['atk_up'],
        skill.data['matk_up'],
        skill.data['martial_arts'],
        skill.data['two_hands'],
        skill.data['two_swords'],
        skill.data['protect'],
        skill.data['shell']
      ]

      io << CSV.generate_line(row, encoding: 'utf-8')
    end

    io.rewind
  end

  private

    def skill_name(skill)
      return "R:#{skill.name}" if skill.reaction?
      return "E:#{skill.name}" if skill.support?
      return "S:#{skill.name}" if skill.movement?

      skill.name
    end
end
