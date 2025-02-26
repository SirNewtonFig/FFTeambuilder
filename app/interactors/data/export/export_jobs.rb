require 'csv'

class Data::Export::ExportJobs < ActiveInteractor::Base
  delegate :io, to: :context

  def perform
    context.io = StringIO.new

    headers = [
      'Job ID',
      'Secondary ID',
      'Sex',
      'Class',
      'Abbreviation',
      'Secondary Name',
      'Innate',
      'Evade',
      'MEvade',
      'HP',
      'MP',
      'Speed',
      'Move',
      'Jump',
      'PA',
      'MA',
      'JP Cost',
      'HPmult',
      'MPmult',
      'SPmult',
      'PAmult',
      'MAmult',
      'Charset'
    ]

    io << CSV.generate_line(headers, encoding: 'utf-8')

    Job.generic.order(:id).each do |job|
      job.data.each do |sex, data|
        row = [
          data['memgen_id'],
          data['secondary_id'],
          sex.upcase,
          job.name,
          job.abbreviation,
          job.skillset,
          data['innate'],
          data['evade'],
          data['m_evade'],
          data['hp'],
          data['mp'],
          data['speed'],
          data['move'],
          data['jump'],
          data['attack'],
          data['magic'],
          data['jp_cost'],
          data['hp_mult'],
          data['mp_mult'],
          data['sp_mult'],
          data['pa_mult'],
          data['ma_mult'],
          data['character_set']
        ]

        io << CSV.generate_line(row, encoding: 'utf-8')
      end
    end

    io.rewind
  end
end
