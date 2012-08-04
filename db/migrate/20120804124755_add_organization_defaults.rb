class AddOrganizationDefaults < ActiveRecord::Migration
  def self.up
    add_column :organizations, :environment_id, :integer
    add_column :organizations, :operatingsystem_id, :integer
    add_column :organizations, :architecture_id, :integer
    add_column :organizations, :medium_id, :integer
    add_column :organizations, :ptable_id, :integer
    add_column :organizations, :domain_id, :integer
    add_column :organizations, :root_pass, :string
    add_column :organizations, :puppetmaster, :string
  end

  def self.down
    remove_column :organizations, :environment_id
    remove_column :organizations, :operatingsystem_id
    remove_column :organizations, :architecture_id
    remove_column :organizations, :medium_id
    remove_column :organizations, :ptable_id
    remove_column :organizations, :domain_id
    remove_column :organizations, :root_pass
    remove_column :organizations, :puppetmaster
  end
end
