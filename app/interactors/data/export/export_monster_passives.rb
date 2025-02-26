require 'csv'

class Data::Export::ExportMonsterPassives < ActiveInteractor::Base
  delegate :io, to: :context

  def perform
    context.io = StringIO.new

    headers = [
      'Monster',
      'Name',
      'Index',
      'JP Cost',
      'Skill ID',
      'HP',
      'MP',
      'PA',
      'MA',
      'Speed',
      'Move',
      'Jump',
      'Phys Evade',
      'Magic Evade',
      'Immune:',
      'Absorbs:',
      'Weak:',
      'Halves:',
      'Strengthens:',
      'Start:',
      'Always:'
    ]

    io << CSV.generate_line(headers, encoding: 'utf-8')

    MonsterPassive.joins(:job).order(Arel.sql "jobs.id, (monster_passives.data ->> 'index')::integer").includes(:job).each do |passive|
      row = [
        passive.job.name,
        passive.name,
        passive.data['index'],
        passive.jp_cost,
        passive.data['memgen_id'],
        passive.data['hp'],
        passive.data['mp'],
        passive.data['attack'],
        passive.data['magic'],
        passive.data['speed'],
        passive.data['move'],
        passive.data['jump'],
        passive.data['ev_p'],
        passive.data['ev_m'],
        passive.data['immune'],
        passive.data['absorbs'],
        passive.data['weakness'],
        passive.data['halves'],
        passive.data['strengthens'],
        passive.data['start'],
        passive.data['always']
      ]

      io << CSV.generate_line(row, encoding: 'utf-8')
    end

    io.rewind
  end
end
