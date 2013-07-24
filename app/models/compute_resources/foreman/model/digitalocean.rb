module Foreman::Model
  class DigitalOcean < ComputeResource

    validates_presence_of :user, :password, :region

    def provided_attributes
      super.merge({ :ip => :public_ip_address })
    end

    def self.model_name
      ComputeResource.model_name
    end

    def capabilities
      [:image]
    end

    def find_vm_by_uuid uuid
      client.servers.get(uuid)
    rescue Fog::Compute::DigitalOcean::Error
      raise(ActiveRecord::RecordNotFound)
    end

    def create_vm args = { }
      super(args)
    rescue Exception => e
      logger.debug "Unhandled Digital Ocean error: #{e.class}:#{e.message}\n " + e.backtrace.join("\n ")
      errors.add(:base, e.message.to_s)
      false
    end

    def security_groups
      ["default"]
    end

    def regions
      ['New York 1', 'Amsterdam 1', 'San Francisco 1']
    end

    def flavors
      client.flavors
    end

    def available_images
      client.images
    end

    def test_connection options = {}
      super and flavors
    rescue Excon::Errors::Unauthorized => e
      errors[:base] << e.response.body
    rescue Fog::Compute::DigitalOcean::Error => e
      errors[:base] << e.message
    end

    def region= value
      self.uuid = value
    end

    def region
      uuid
    end

    def destroy_vm(uuid)
      vm = find_vm_by_uuid(uuid)
      vm.destroy if vm
      true
    end

    # not supporting update at the moment
    def update_required?(old_attrs, new_attrs)
      false
    end

    def provider_friendly_name
      "Digital Ocean"
    end

    private

    def client
      @client = Fog::Compute.new(
        :provider => 'DigitalOcean',
        :digitalocean_client_id => username,
        :digitalocean_api_key => password
      )
      return @client
    end

    def vm_instance_defaults
      super.merge(
        # The ID for a 512MB instance.
        :flavor_id => 66
      )
    end

  end
end
