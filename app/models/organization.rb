class Organization < ActiveRecord::Base
  include Foreman::ThreadSession::OrganizationModel
  audited
  has_associated_audits

  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :organization_users, :dependent => :destroy
  has_many :users, :through => :organization_users
  has_many :organization_smart_proxies, :dependent => :destroy
  has_many :smart_proxies, :through => :organization_smart_proxies
  has_many :organization_compute_resources, :dependent => :destroy
  has_many :compute_resources, :through => :organization_compute_resources
  has_many :organization_media, :dependent => :destroy
  has_many :media, :through => :organization_media
  has_many :organization_domains, :dependent => :destroy
  has_many :domains, :through => :organization_domains
  has_many :organization_hostgroups, :dependent => :destroy
  has_many :hostgroups, :through => :organization_hostgroups
  has_many :organization_environments, :dependent => :destroy
  has_many :environments, :through => :organization_environments
  has_many :organization_puppetclasses, :dependent => :destroy
  has_many :puppetclasses, :through => :organization_puppetclasses
  has_one :organization_subnets, :dependent => :destroy
  has_one :subnet, :through => :organization_subnets

  has_many :organization_parameters, :dependent => :destroy, :foreign_key => :reference_id
  accepts_nested_attributes_for :organization_parameters, :reject_if => lambda { |a| a[:value].blank? }, :allow_destroy => true

  scoped_search :on => :name, :complete_value => true

  def to_param
    name
  end


  def self.with_org_scope
    if SETTINGS[:orgs_enabled] and not User.current.admin?
      # the join with organizations should exclude all objects not in the user's
      # current org(s) ... if the user has no current org, then the user will
      # see no objects as a result of this join
      org_ids = [Organization.current].flatten
      org_ids = org_ids.any? ? org_ids.map(&:id) : nil
      scope = yield
      scope = scope.joins(:organizations).where("organizations.id in (?)", org_ids)

      # by default, joins result in readonly records; override
      scope = scope.readonly(false)
    end
    scope
  end


  def self.when_single_org
    unless User.current.admin?
      if SETTINGS[:single_org]
        yield if block_given?
      end
    end
  end
end
