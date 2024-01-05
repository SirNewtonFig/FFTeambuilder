class Jan2024DataEdits < ActiveRecord::Migration[7.0]
  def up
    Item.find_by(name: 'Thunder Rod').update(name: 'Kaiser Rod')
    Skill.find_by(name: 'Overflow').update(name: 'Lucky')
  end

  def down
    # no-op
  end
end
