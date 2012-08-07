class AddOrganizationSubnet < ActiveRecord::Migration
  def self.up
    create_table :organization_subnet do |t|
      t.integer :organization_id
      t.integer :subnet_id
    end

    add_column :organizations, :subnet_id, :integer
  end

  def self.down
    drop_table :organization_subnet
  end
end
