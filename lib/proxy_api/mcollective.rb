module ProxyAPI
  class Mcollective < ProxyAPI::Resource
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
  end
end
