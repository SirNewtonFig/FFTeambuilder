# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users, id: :uuid do |t|
      t.text :username, null: false
      t.text :uid
      t.string :encrypted_password, null: false, default: ''

      t.timestamps null: false
    end
  end
end
