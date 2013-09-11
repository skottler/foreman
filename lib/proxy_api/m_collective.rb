module ProxyAPI
  class MCollective < ProxyAPI::Resource
    def initialize args
      @url  = args[:url] + "/mcollective"
      super args
    end

    def install_package(name, args = {})
      parse(post(args, "packages/#{name}"))
    end

    def delete_package(name, args = {})
      parse(delete("packages/#{name}"))
    end

    def start_service(name, args = {})
      parse(post(args, "services/#{name}/start"))
    end

    def restart_service(name, args = {})
      parse(post(args, "services/#{name}/restart"))
    end

    def stop_service(name, args = {})
      parse(post("services/#{name}/stop"))
    end
  end
end
