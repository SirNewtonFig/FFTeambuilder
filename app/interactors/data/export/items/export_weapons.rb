require 'csv'

class Data::Export::Items::ExportWeapons < ActiveInteractor::Base
  delegate :io, to: :context

  def perform
    context.io = StringIO.new

    headers = [
      'Name',
      'Skill',
      'Item ID',
      'WP',
      'W-EV',
      'Flags',
      'Classes',
      'PA',
      'MA',
      'Speed',
      'Move',
      'Jump',
      'Adds:',
      'Immune:',
      'Cancels:',
      'Element:',
      'Proc:',
      'Weak:',
      'Absorbs:',
      'Strengthens:',
      'Start:',
      'Always:',
      'XA:',
      'Formula:',
      'Proc Formula:',
      'Proc Rate:',
      'Extra Effects:'
    ]

    io << CSV.generate_line(headers, encoding: 'utf-8')

    Item.weapon.order(:id).includes(:jobs).each do |item|
      row = [
        item.name,
        item.skills.first&.name,
        item.data['item_id'],
        item.data['wp'],
        item.data['w_ev'],
        item.data['flags'],
        item.jobs.pluck(:abbreviation).join(' '),
        item.data['attack'],
        item.data['magic'],
        item.data['speed'],
        item.data['move'],
        item.data['jump'],
        item.data['add'],
        item.data['immune'],
        item.data['cancels'],
        item.data['element'],
        item.data['proc'],
        item.data['weakness'],
        item.data['absorbs'],
        item.data['strengthens'],
        item.data['start'],
        item.data['always'],
        item.data['xa'],
        item.data['formula'],
        item.data['proc_formula'],
        item.data['proc_rate'],
        item.data['extra_effects']
      ]

      io << CSV.generate_line(row, encoding: 'utf-8')
    end

    io.rewind
  end
end
