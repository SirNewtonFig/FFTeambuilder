class CreateJobs < ActiveRecord::Migration[7.0]
  def change
    create_table :jobs do |t|
      t.text :name
      t.text :skillset
      t.text :abbreviation
      t.jsonb :data

      t.timestamps
    end

    create_table :prerequisites do |t|
      t.belongs_to :job
      t.belongs_to :prerequisite
      t.integer :level
      
      t.timestamps
    end
  end
end
