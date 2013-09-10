class McollectiveController < ApplicationController
  before_filter :find_smart_proxy, :only => [:submit_install_packages, :submit_uninstall_packages]
  before_filter :package_name, :only => [:submit_install_packages, :submit_uninstall_packages]

  def install_packages
  end

  def submit_install_packages
    response = ProxyAPI::Mcollective.new({:url => @mc_proxy.url}).install_package(@package_name)

    # TODO handle partial successes/failures
    if response[0]["statuscode"] == 0
      process_success :success_redirect => hosts_path(), :success_msg => _("successfully installed package %s") % @package_name
    else
      process_error :redirect => hosts_path(), :error_msg => _("failed to install package '%s': %s") % [@package_name, response[0]["statusmsg"]]
    end
  rescue => e
    process_error :redirect => hosts_path(), :error_msg => _("failed to install a package: %s") % e
  end

  def uninstall_packages
  end

  def submit_uninstall_packages
    response = ProxyAPI::Mcollective.new({:url => @mc_proxy.url}).delete_package(@package_name)

    if response[0]["statuscode"] == 0
      process_success :success_redirect => hosts_path(), :success_msg => _("successfully uninstalled package %s") % @package_name
    else
      process_error :redirect => hosts_path(), :error_msg => _("failed to uninstall package '%s': %s") % [@package_name, response[0]["statusmsg"]]
    end
  rescue => e
    process_error :redirect => hosts_path(), :error_msg => _("failed to uninstall a package: %s") % e
  end

  def find_smart_proxy
    @mc_proxy = SmartProxy.joins(:features).where("features.name" => "MCollective").first
    return process_error :redirect => :back, :error_msg => _("There are no configured mcollective proxies") unless @mc_proxy
  end

  def package_name
    @package_name = params[:package][:name]
  end
end
