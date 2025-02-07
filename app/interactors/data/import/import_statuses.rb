class Data::Import::ImportStatuses < ActiveInteractor::Base
  delegate :statuses, to: :context

  def perform
    statuses.each do |row|
      status = Status.find_or_initialize_by(name: row['Status'])
    
      status.update(
        default_priority: row['Default Priority'].to_i,    # could be N/A, coerce it to 0
        description: row['Description'],
        duration: row['Duration'],
        indicator: row['Indicator'],
        upgrades_to: row['Upgrades To'],
        upgrade_effect: row['Upgrade Effect'],
        show_priority: row['Default Priority'] != 'N/A'
      )
    end
  end
end
