require 'csv'

class Data::Export::Items::ExportAccessories < ActiveInteractor::Base
  delegate :io, to: :context

  def perform
    context.io = StringIO.new

    headers = [
      'Name',
      'Item ID',
      'Classes',
      'Phys Evade',
      'Magic Evade',
      'PA',
      'MA',
      'Speed',
      'Move',
      'Jump',
      'Immune:',
      'Absorbs:',
      'Weak:',
      'Halves:',
      'Strengthens:',
      'Start:',
      'Always:'
    ]

    io << CSV.generate_line(headers, encoding: 'utf-8')

    Item.accessory.order(:id).includes(:jobs).each do |item|
      row = [
        item.name,
        item.data['memgen_id'],
        item.jobs.pluck(:abbreviation).join(' '),
        item.data['ev_p'],
        item.data['ev_m'],
        item.data['attack'],
        item.data['magic'],
        item.data['speed'],
        item.data['move'],
        item.data['jump'],
        item.data['immune'],
        item.data['absorbs'],
        item.data['weakness'],
        item.data['halves'],
        item.data['strengthens'],
        item.data['start'],
        item.data['always']
      ]

      io << CSV.generate_line(row, encoding: 'utf-8')
    end

    io.rewind
  end
end
