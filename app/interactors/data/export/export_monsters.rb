require 'csv'

class Data::Export::ExportMonsters < ActiveInteractor::Base
  delegate :io, to: :context

  def perform
    context.io = StringIO.new

    headers = [
      'Name',
      'Job ID',
      'JP Cost',
      'Evade',
      'MEvade',
      'HPmult',
      'MPmult',
      'SPmult',
      'PAmult',
      'MAmult',
      'HP',
      'MP',
      'Speed',
      'Move',
      'Jump',
      'PA',
      'MA',
      'Notes'
    ]

    io << CSV.generate_line(headers, encoding: 'utf-8')

    Job.monster.order(:id).each do |job|
      job.data.each do |_x, data|
        row = [
          job.name,
          data['memgen_id'],
          data['jp_cost'],
          data['evade'],
          data['m_evade'],
          data['hp_mult'],
          data['mp_mult'],
          data['sp_mult'],
          data['pa_mult'],
          data['ma_mult'],
          data['hp'],
          data['mp'],
          data['speed'],
          data['move'],
          data['jump'],
          data['attack'],
          data['magic'],
          data['notes']
        ]

        io << CSV.generate_line(row, encoding: 'utf-8')
      end
    end

    io.rewind
  end
end
