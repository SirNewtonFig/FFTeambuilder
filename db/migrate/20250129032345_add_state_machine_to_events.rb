class AddStateMachineToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :state, :text, default: 'open'

    Event.reset_column_information

    reversible do |dir|
      dir.up do
        Event.where.not(data: {}).update_all(state: 'published')
      end
    end
  end
end
