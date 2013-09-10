class McollectiveController < ApplicationController
  def install_packages
  end

  def submit_install_packages
    mc_proxy = SmartProxy.joins(:features).where("features.name" => "MCollective").first
    return process_error :redirect => :back, :error_msg => _("There are no configured mcollective proxies") unless mc_proxy

    package_name = params[:package][:name]
    response = ProxyAPI::Mcollective.new({:url => mc_proxy.url}).install_package(package_name)

    # TODO handle partial successes/failures
    if response[0]["statuscode"] == 0
      process_success :success_redirect => hosts_path(), :success_msg => _("successfully installed package %s" % package_name)
    else
      process_error :redirect => hosts_path(), :error_msg => _("failed to install package '%s': %s") % package_name, response[0]["statusmsg"]
    end
  rescue => e
    process_error :redirect => hosts_path(), :error_msg => _("failed to install a package: %s") % e
  end
end
