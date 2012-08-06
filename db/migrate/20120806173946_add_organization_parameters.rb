class AddOrganizationParameters < ActiveRecord::Migration
  def self.up
    add_column :parameters, :organization_id, :integer
  end

  def self.down
    remove_column :parameters, :organization_id
  end
end
