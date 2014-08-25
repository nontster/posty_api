class AddHostToVirtualUsers < ActiveRecord::Migration
  def self.up
    add_column :virtual_users, :host, :string, :limit => 15, :default => '192.168.108.5'
  end

  def self.down
    remove_column :virtual_users, :host
  end
end
