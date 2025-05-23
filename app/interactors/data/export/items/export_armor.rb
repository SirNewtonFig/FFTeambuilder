require 'csv'

class Data::Export::Items::ExportArmor < ActiveInteractor::Base
  delegate :io, to: :context

  def perform
    context.io = StringIO.new

    headers = [
      'Name',
      'Item ID',
      'Classes',
      'HP',
      'MP',
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
      'Always:',
      'Skill',
      'Extra Items',
      'Extra Effects:'
    ]

    io << CSV.generate_line(headers, encoding: 'utf-8')

    Item.armor.order(:id).includes(:jobs, :skills).each do |item|
      row = [
        item.name,
        item.data['memgen_id'],
        item.jobs.pluck(:abbreviation).join(' '),
        item.data['hp'],
        item.data['mp'],
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
        item.data['always'],
        item.skills.first&.name,
        item.data['extra_items'],
        item.data['extra_effects']
      ]

      io << CSV.generate_line(row, encoding: 'utf-8')
    end

    io.rewind
  end
end
