class AddJpCache < ActiveRecord::Migration[7.0]
  def change
    add_column :teams, :jp_total, :integer, default: 0

    Team.reset_column_information
    
    reversible do |dir|
      dir.up do
        Team.joins(:submissions).each do |t|
          t.update(jp_total: t.characters.map(&:jp_total).sum)
        end
      end
    end
  end
end
