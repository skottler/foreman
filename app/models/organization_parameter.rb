class OrganizationParameter < Parameter
  belongs_to :organization, :foreign_key => :reference_id
  audited :except => [ :priority ], :associated_with => :organization
  validates_uniqueness_of :name, :scope => :reference_id

  private
  def enforce_permissions operation
    return true if operation == "edit" and new_record?

    if User.current.allowed_to?("#{operation}_params".to_sym)
      if User.current.organizations.empty? or User.current.include? organization
        return true
      end
    end
    errors.add :base, "You do not have permission to #{operation} this organization parameter"
  end
end
