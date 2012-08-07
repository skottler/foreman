class OrganizationSubnet < ActiveRecord::Base
  belongs_to :organization
  has_one :subnet

  validates_uniqueness_of :organization_id, :scope => :subnet_id
end
