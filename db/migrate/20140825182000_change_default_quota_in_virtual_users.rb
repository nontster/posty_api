class ChangeDefaultQuotaInVirtualUsers < ActiveRecord::Migration
  def self.up
    change_column :virtual_users, :quota, :integer, :limit => 8, :default => 100
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration, "Can't change the default"
  end
end
