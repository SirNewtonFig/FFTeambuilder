class AddStatusUpgradeColumns < ActiveRecord::Migration[7.0]
  def change
    add_column :statuses, :upgrades_to, :text
    add_column :statuses, :upgrade_effect, :text
  end
end
