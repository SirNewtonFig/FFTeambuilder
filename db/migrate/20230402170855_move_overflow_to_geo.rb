class MoveOverflowToGeo < ActiveRecord::Migration[7.0]
  def change
    geo = Job.find_by(name: 'Geomancer')

    Skill.find_by(name: 'Overflow').update(job: geo)
  end
end
