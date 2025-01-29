class AddChallongeCredentials < ActiveRecord::Migration[7.0]
  def change
    create_table :challonge_credentials do |t|
      t.belongs_to :user, type: :uuid
      t.text :username
      t.text :key
    end
  end
end
