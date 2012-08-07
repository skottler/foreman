class AddOrganizationColumnToHost < ActiveRecord::Migration
  def self.up
    add_column :hosts, :organization_id, :integer
  end

  def self.down
    remove_column :hosts, :organization_id
  end
end
