require 'csv'

class Data::Export::ExportStatuses < ActiveInteractor::Base
  delegate :io, to: :context

  def perform
    context.io = StringIO.new

    headers = [
      'Status',
      'Description',
      'Duration',
      'Indicator',
      'Default Priority',
      'Upgrades To',
      'Upgrade Effect'
    ]

    io << CSV.generate_line(headers, encoding: 'utf-8')

    Status.order(:id).each do |status|
      row = [
        status.name,
        status.description,
        status.duration,
        status.indicator,
        status.show_priority? ? status.default_priority : 'N/A',
        status.upgrades_to,
        status.upgrade_effect
      ]

      io << CSV.generate_line(row, encoding: 'utf-8')
    end

    io.rewind
  end
end
